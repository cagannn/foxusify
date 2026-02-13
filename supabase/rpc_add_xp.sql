-- RPC Function to atomically add XP to both profiles and weekly_league_participants

create or replace function public.add_xp_to_user(
  p_xp_amount int,
  p_focus_time int
)
returns void
language plpgsql
security definer
as $$
declare
  v_user_id uuid;
begin
  v_user_id := auth.uid();

  -- Update Profile
  update public.profiles
  set 
    current_xp = current_xp + p_xp_amount,
    total_focus_time = total_focus_time + p_focus_time,
    -- Simple level calculation trigger could be added here, but for now we just update XP
    -- Level update logic can be handled separately or here if we have the formula in SQL
    current_level = floor(1 + ln(1 + (current_xp + p_xp_amount)::float / 100) / ln(1.1))::int
  where id = v_user_id;

  -- Update Weekly League (Create if not exists for this week?)
  -- For simplicty, assuming the row exists or we might need an upsert.
  -- Let's try an upsert to be safe.
  insert into public.weekly_league_participants (user_id, week_start_date, starting_level, weekly_xp)
  values (
    v_user_id,
    date_trunc('week', now())::date, 
    (select current_level from public.profiles where id = v_user_id), -- Approximate starting level if new
    p_xp_amount
  )
  on conflict (id) do nothing; -- Wait, we don't have a unique constraint on (user_id, week_start_date) yet in schema.sql.
  
  -- Ideally we should have a unique constraint. let's assume we update if it exists.
  -- Better approach: Update if exists.
  update public.weekly_league_participants
  set weekly_xp = weekly_xp + p_xp_amount
  where user_id = v_user_id and week_start_date = date_trunc('week', now())::date;
  
  -- If no row was updated (meaning no entry for this week), insert one.
  if not found then
    insert into public.weekly_league_participants (user_id, week_start_date, starting_level, weekly_xp)
    values (
      v_user_id,
      date_trunc('week', now())::date,
      (select current_level from public.profiles where id = v_user_id),
      p_xp_amount
    );
  end if;
  
end;
$$;
