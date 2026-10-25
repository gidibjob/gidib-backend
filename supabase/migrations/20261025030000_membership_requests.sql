-- Solicitações de associação enviadas pelo formulário público /associe-se.

create table public.membership_requests (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 200),
  email text not null check (char_length(email) between 3 and 320),
  phone text check (char_length(phone) <= 40),
  member_type text not null
    check (member_type in ('profissional', 'estudante', 'empresa')),
  organization text check (char_length(organization) <= 200),
  job_title text check (char_length(job_title) <= 200),
  city text check (char_length(city) <= 120),
  message text check (char_length(message) <= 3000),
  consent boolean not null,
  status text not null default 'new'
    check (status in ('new', 'in_review', 'approved', 'rejected')),
  created_at timestamptz not null default now()
);

create index membership_requests_status_created_idx
  on public.membership_requests (status, created_at desc);

alter table public.membership_requests enable row level security;

-- Visitante só cria solicitações novas e com consentimento (LGPD).
create policy "membership_requests: visitante envia"
  on public.membership_requests for insert
  to anon, authenticated
  with check (status = 'new' and consent = true);

create policy "membership_requests: admin lê"
  on public.membership_requests for select
  to authenticated using ((select public.is_admin()));
create policy "membership_requests: admin atualiza"
  on public.membership_requests for update
  to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()));
create policy "membership_requests: admin apaga"
  on public.membership_requests for delete
  to authenticated using ((select public.is_admin()));
