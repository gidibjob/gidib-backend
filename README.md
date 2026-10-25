# gidib-backend

Backend do projeto Gidib, baseado em Supabase (Postgres, Auth, Storage, Edge Functions).

## Estrutura

- `supabase/migrations/` — migrations SQL versionadas
- `supabase/functions/` — Edge Functions
- `supabase/seed.sql` — dados de seed para desenvolvimento local
- `supabase/config.toml` — configuração do projeto Supabase local

## Uso

```bash
# subir o stack local (Docker precisa estar rodando)
npx supabase start

# aplicar migrations + seed
npx supabase db reset

# linkar com o projeto remoto
npx supabase link --project-ref <PROJECT_REF>

# subir migrations para o projeto remoto
npx supabase db push

# criar uma nova migration
npx supabase migration new <nome>
```

Configure as variáveis de `.env.example` em um `.env` local (não versionado).

## Schema de conteúdo

A migration `20261025000000_content_schema.sql` cria:

- `categories`, `tags`, `posts`, `events`, `projects`, `partners`, `contact_messages`
- bucket público `media` (Storage) para imagens
- RLS: visitantes leem apenas conteúdo publicado e podem enviar mensagens de contato; só admins escrevem

### Primeiro acesso (admin)

1. Crie o usuário em **Authentication → Users** no painel do Supabase (e-mail + senha).
2. Promova-o a admin no **SQL Editor**:

```sql
insert into public.admin_users (user_id)
select id from auth.users where email = 'voce@gidib.org.br';
```

### Dados iniciais no projeto remoto

`db push` não roda o seed. Para popular o remoto com o conteúdo original, cole `supabase/seed.sql` no SQL Editor.
