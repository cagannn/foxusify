-- 1. Önce eski trigger ve fonksiyonu temizleyelim (Hata vermemesi için 'if exists' kullanıyoruz)
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();

-- 2. Fonksiyonu tekrar oluşturalım
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, username)
  values (
    new.id, 
    new.email, 
    new.raw_user_meta_data ->> 'username' -- Metadata'dan username'i almaya çalış
  );
  return new;
end;
$$;

-- 3. Trigger'ı tekrar bağlayalım
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 4. Varsa eksik profilleri de oluşturalım (Daha önce auth'a eklenmiş ama profile'ı olmayanlar için)
insert into public.profiles (id, email)
select id, email from auth.users
where id not in (select id from public.profiles);
