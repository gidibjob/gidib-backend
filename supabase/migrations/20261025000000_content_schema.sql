-- Schema de conteúdo gerenciável do site GIDIB.
-- Leitura pública apenas do que está publicado; escrita restrita a admins.

create extension if not exists pgcrypto;

-- ---------------------------------------------------------------- admins
create table public.admin_users (
  user_id uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.admin_users enable row level security;

create function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.admin_users where user_id = (select auth.uid())
  );
$$;

create policy "admin_users: leitura do próprio registro"
  on public.admin_users for select
  to authenticated
  using (user_id = (select auth.uid()));

-- ---------------------------------------------------------- updated_at
create function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ------------------------------------------------- categorias e tags
create table public.categories (
  name text primary key,
  created_at timestamptz not null default now()
);

create table public.tags (
  name text primary key,
  created_at timestamptz not null default now()
);

-- ----------------------------------------------------------------- posts
create table public.posts (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  excerpt text not null,
  category text not null references public.categories (name)
    on update cascade on delete restrict,
  author text not null default 'Equipe GIDIB',
  image text not null default '',
  tags text[] not null default '{}',
  content text[] not null default '{}',
  reading_time text not null default '5 min de leitura',
  related_slugs text[] not null default '{}',
  status text not null default 'draft'
    check (status in ('draft', 'scheduled', 'published', 'archived')),
  publish_at date,
  published_at timestamptz,
  seo_title text,
  seo_description text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index posts_status_published_at_idx
  on public.posts (status, published_at desc);

create trigger posts_set_updated_at
  before update on public.posts
  for each row execute function public.set_updated_at();

create function public.set_post_published_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.published_at is null then
    if new.status = 'published' then
      new.published_at = now();
    elsif new.status = 'scheduled' and new.publish_at is not null then
      new.published_at = new.publish_at::timestamptz;
    end if;
  end if;
  return new;
end;
$$;

create trigger posts_set_published_at
  before insert or update on public.posts
  for each row execute function public.set_post_published_at();

-- ---------------------------------------------------------------- eventos
create table public.events (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  description text not null,
  modality text not null
    check (modality in ('Presencial', 'Online', 'Workshop', 'Webinar', 'Encontro')),
  event_date date not null,
  event_time text not null default '19:00',
  location text not null,
  registration_url text not null default '#',
  status text not null default 'draft'
    check (status in ('draft', 'published', 'closed', 'cancelled')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index events_status_date_idx on public.events (status, event_date);

create trigger events_set_updated_at
  before update on public.events
  for each row execute function public.set_updated_at();

-- --------------------------------------------------------------- projetos
create table public.projects (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  title text not null,
  description text not null,
  category text not null,
  image text not null default '',
  sort_order integer not null default 0,
  published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger projects_set_updated_at
  before update on public.projects
  for each row execute function public.set_updated_at();

-- --------------------------------------------------------------- parceiros
create table public.partners (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  website_url text,
  sort_order integer not null default 0,
  published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger partners_set_updated_at
  before update on public.partners
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------- mensagens de contato
create table public.contact_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 200),
  email text not null check (char_length(email) between 3 and 320),
  subject text check (char_length(subject) <= 300),
  message text not null check (char_length(message) between 1 and 5000),
  read boolean not null default false,
  created_at timestamptz not null default now()
);

-- -------------------------------------------------------------------- RLS
alter table public.categories enable row level security;
alter table public.tags enable row level security;
alter table public.posts enable row level security;
alter table public.events enable row level security;
alter table public.projects enable row level security;
alter table public.partners enable row level security;
alter table public.contact_messages enable row level security;

-- Categorias e tags: leitura pública, escrita admin.
create policy "categories: leitura pública" on public.categories
  for select to anon, authenticated using (true);
create policy "categories: admin escreve" on public.categories
  for all to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()));

create policy "tags: leitura pública" on public.tags
  for select to anon, authenticated using (true);
create policy "tags: admin escreve" on public.tags
  for all to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()));

-- Posts: público vê publicados (ou agendados cuja data já chegou).
create policy "posts: leitura pública do publicado" on public.posts
  for select to anon, authenticated
  using (
    status = 'published'
    or (status = 'scheduled' and publish_at <= current_date)
  );
create policy "posts: admin tudo" on public.posts
  for all to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()));

-- Eventos: público vê publicados e encerrados.
create policy "events: leitura pública" on public.events
  for select to anon, authenticated
  using (status in ('published', 'closed'));
create policy "events: admin tudo" on public.events
  for all to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()));

create policy "projects: leitura pública" on public.projects
  for select to anon, authenticated using (published);
create policy "projects: admin tudo" on public.projects
  for all to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()));

create policy "partners: leitura pública" on public.partners
  for select to anon, authenticated using (published);
create policy "partners: admin tudo" on public.partners
  for all to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()));

-- Contato: qualquer visitante envia; só admin lê/gerencia.
create policy "contact_messages: visitante envia" on public.contact_messages
  for insert to anon, authenticated
  with check (read = false);
create policy "contact_messages: admin lê" on public.contact_messages
  for select to authenticated using ((select public.is_admin()));
create policy "contact_messages: admin atualiza" on public.contact_messages
  for update to authenticated
  using ((select public.is_admin())) with check ((select public.is_admin()));
create policy "contact_messages: admin apaga" on public.contact_messages
  for delete to authenticated using ((select public.is_admin()));

-- --------------------------------------------------------------- Storage
insert into storage.buckets (id, name, public)
values ('media', 'media', true)
on conflict (id) do nothing;

create policy "media: leitura pública" on storage.objects
  for select to anon, authenticated using (bucket_id = 'media');
create policy "media: admin envia" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'media' and (select public.is_admin()));
create policy "media: admin atualiza" on storage.objects
  for update to authenticated
  using (bucket_id = 'media' and (select public.is_admin()));
create policy "media: admin apaga" on storage.objects
  for delete to authenticated
  using (bucket_id = 'media' and (select public.is_admin()));
