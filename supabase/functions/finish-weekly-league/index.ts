import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

// VS Code (without proper Deno configuration) might complain about 'Deno'.
// This declaration silences the error for the IDE while still working in the runtime.
declare const Deno: any;

// Define interfaces for database rows
interface WeeklyParticipant {
    user_id: string;
    starting_level: number;
    weekly_xp: number;
}

interface Profile {
    id: string;
    current_level: number;
}

interface PendingReward {
    user_id: string;
    reward_type: string;
    week_date: string;
    is_claimed: boolean;
}

// Deno server handler
Deno.serve(async (req: Request) => {
    try {
        // 1. Initialize Supabase Client with Service Role Key (Admin Access)
        const supabaseAdmin = createClient(
            Deno.env.get('SUPABASE_URL') ?? '',
            Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
        )

        // 2. Calculate Dates
        const now = new Date()
        // Calculate the start of the *previous* week (Monday)
        const lastWeekStart = new Date(now)
        lastWeekStart.setDate(now.getDate() - 7)
        // Format as YYYY-MM-DD
        const lastWeekDateStr = lastWeekStart.toISOString().split('T')[0]

        // The "new" week starts today (now)
        const thisWeekDateStr = now.toISOString().split('T')[0]

        console.log(`Processing league for week starting: ${lastWeekDateStr}`)

        // 3. Fetch Weekly League Data
        const { data: participants, error: fetchError } = await supabaseAdmin
            .from('weekly_league_participants')
            .select('user_id, starting_level, weekly_xp')
            .eq('week_start_date', lastWeekDateStr)

        if (fetchError) throw fetchError
        if (!participants || participants.length === 0) {
            return new Response(JSON.stringify({ message: 'No participants found for last week.' }), {
                headers: { 'Content-Type': 'application/json' },
                status: 200
            })
        }

        // Cast participants to strongly typed array
        const typedParticipants = participants as WeeklyParticipant[];

        // 4. Group by Starting Level
        const leagueGroups: Record<number, WeeklyParticipant[]> = {}
        typedParticipants.forEach((p) => {
            if (!leagueGroups[p.starting_level]) {
                leagueGroups[p.starting_level] = []
            }
            leagueGroups[p.starting_level].push(p)
        })

        const rewardsToInsert: PendingReward[] = []

        // 5. Determine Winners for each Level
        for (const levelStr in leagueGroups) {
            const levelParticipants = leagueGroups[levelStr]

            // Sort by weekly_xp DESC
            levelParticipants.sort((a, b) => b.weekly_xp - a.weekly_xp)

            // Top 3 Winners
            const winners = levelParticipants.slice(0, 3)

            winners.forEach((winner, index) => {
                // Only award if they have > 0 XP
                if (winner.weekly_xp > 0) {
                    let rewardType = ''
                    if (index === 0) rewardType = '1st_place'
                    else if (index === 1) rewardType = '2nd_place'
                    else if (index === 2) rewardType = '3rd_place'

                    rewardsToInsert.push({
                        user_id: winner.user_id,
                        reward_type: rewardType,
                        week_date: lastWeekDateStr,
                        is_claimed: false
                    })
                }
            })
        }

        // 6. Insert Rewards
        if (rewardsToInsert.length > 0) {
            const { error: rewardError } = await supabaseAdmin
                .from('pending_rewards')
                .insert(rewardsToInsert)

            if (rewardError) throw rewardError
            console.log(`Issued ${rewardsToInsert.length} rewards.`)
        }

        // 7. Start New Week (Reset Logic)
        const { data: allProfiles, error: profilesError } = await supabaseAdmin
            .from('profiles')
            .select('id, current_level')

        if (profilesError) throw profilesError

        // Cast profiles
        const typedProfiles = allProfiles as Profile[];

        const newWeekParticipants: any[] = []

        typedProfiles.forEach((profile) => {
            newWeekParticipants.push({
                user_id: profile.id,
                week_start_date: thisWeekDateStr,
                starting_level: profile.current_level, // Lock in their NEW level
                weekly_xp: 0
            })
        })

        if (newWeekParticipants.length > 0) {
            const { error: newWeekError } = await supabaseAdmin
                .from('weekly_league_participants')
                .insert(newWeekParticipants)

            if (newWeekError) console.error("Error creating new week:", newWeekError)
            else console.log(`Initialized ${newWeekParticipants.length} players for new week.`)
        }

        return new Response(
            JSON.stringify({
                message: 'Weekly league finished successfully.',
                rewards_issued: rewardsToInsert.length,
                new_week_participants: newWeekParticipants.length
            }),
            { headers: { 'Content-Type': 'application/json' } }
        )
    } catch (err: unknown) {
        console.error(err)
        const errorMessage = err instanceof Error ? err.message : String(err)
        return new Response(JSON.stringify({ error: errorMessage }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        })
    }
})

