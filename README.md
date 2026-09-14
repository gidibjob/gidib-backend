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
