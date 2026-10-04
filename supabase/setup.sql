-- Run this entire file in the project's Supabase SQL Editor.
-- Shared catalogue: signed-in users can read; only the creator can edit/delete.
begin;

create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null default auth.uid() references auth.users(id),
  judul text not null check (length(trim(judul)) between 1 and 200),
  penulis text not null check (length(trim(penulis)) between 1 and 200),
  penerbit text not null default '' check (length(penerbit) <= 200),
  tahun_terbit integer not null check (tahun_terbit between 1 and 9999),
  stok integer not null check (stok >= 0),
  kategori text not null check (length(trim(kategori)) between 1 and 100),
  foto text,
  created_at timestamptz not null default now()
);

alter table public.books enable row level security;
revoke all on public.books from anon;
grant select, insert, update, delete on public.books to authenticated;

drop policy if exists books_read on public.books;
create policy books_read on public.books for select to authenticated using (true);
drop policy if exists books_insert on public.books;
create policy books_insert on public.books for insert to authenticated
  with check ((select auth.uid()) = owner_id);
drop policy if exists books_update on public.books;
create policy books_update on public.books for update to authenticated
  using ((select auth.uid()) = owner_id)
  with check ((select auth.uid()) = owner_id);
drop policy if exists books_delete on public.books;
create policy books_delete on public.books for delete to authenticated
  using ((select auth.uid()) = owner_id);

create index if not exists books_owner_id_idx on public.books(owner_id);
create index if not exists books_created_at_idx on public.books(created_at desc);

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('book-covers', 'book-covers', true, 5242880,
  array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do update set public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists covers_insert on storage.objects;
create policy covers_insert on storage.objects for insert to authenticated
  with check (bucket_id = 'book-covers' and
    (storage.foldername(name))[1] = (select auth.uid())::text);
drop policy if exists covers_select on storage.objects;
create policy covers_select on storage.objects for select to authenticated
  using (bucket_id = 'book-covers' and
    (storage.foldername(name))[1] = (select auth.uid())::text);
drop policy if exists covers_delete on storage.objects;
create policy covers_delete on storage.objects for delete to authenticated
  using (bucket_id = 'book-covers' and
    (storage.foldername(name))[1] = (select auth.uid())::text);

commit;
