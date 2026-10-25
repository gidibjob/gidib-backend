-- Papéis do painel: 'admin' gerencia conteúdo e usuários; 'editor' só conteúdo.
-- O gerenciamento de usuários roda no servidor do frontend com a service_role,
-- então não há policies de escrita em admin_users para o cliente.

alter table public.admin_users
  add column role text not null default 'editor'
  check (role in ('admin', 'editor'));

-- Quem já existia antes desta migration é administrador geral.
update public.admin_users set role = 'admin';

create function public.is_super_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.admin_users
    where user_id = (select auth.uid()) and role = 'admin'
  );
$$;
