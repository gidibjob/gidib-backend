-- Dados iniciais (gerado a partir do conteúdo original do site).
-- Roda após `supabase db reset`.

insert into public.categories (name) values
  ('Tecnologia'),
  ('Indústria'),
  ('Carreira'),
  ('Inovação'),
  ('Sustentabilidade'),
  ('GIDIB')
on conflict do nothing;

insert into public.tags (name) values
  ('Carreira'),
  ('Dados'),
  ('ESG'),
  ('Eventos'),
  ('GIDIB'),
  ('IA'),
  ('Indústria 4.0'),
  ('Inovação'),
  ('Manutenção'),
  ('Power BI'),
  ('Qualificação'),
  ('Startups'),
  ('Sustentabilidade')
on conflict do nothing;

insert into public.posts (slug, title, excerpt, category, author, image, tags, content, reading_time, related_slugs, status, published_at) values
  ('como-a-ia-esta-transformando-a-manutencao-industrial', 'Como a IA está transformando a manutenção industrial', 'A inteligência artificial vem revolucionando a forma como as indústrias gerenciam seus ativos, aumentando a disponibilidade e reduzindo custos.', 'Tecnologia', 'Equipe GIDIB', 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800&q=80', array['IA', 'Manutenção', 'Indústria 4.0', 'Dados']::text[], array['A manutenção industrial está passando por uma transformação significativa com o uso da inteligência artificial. Com algoritmos avançados que analisam dados em tempo real, é possível prever falhas, otimizar recursos e aumentar a vida útil dos equipamentos.', 'Neste artigo, exploramos como a IA está sendo aplicada à manutenção industrial, quais os principais benefícios e como uma empresa pode começar a implementar essa tecnologia.']::text[], '5 min de leitura', array['power-bi-na-industria-dados-que-geram-resultados', 'as-competencias-mais-valorizadas-na-industria-em-2027', 'startups-que-estao-revolucionando-a-industria', 'industria-verde-e-amarela-oportunidades-e-desafios', 'evento-gidib-2026-inscricoes-abertas']::text[], 'published', '2026-09-12'),
  ('power-bi-na-industria-dados-que-geram-resultados', 'Power BI na indústria: dados que geram resultados', 'Como ferramentas de business intelligence estão ajudando indústrias a tomar decisões mais rápidas e assertivas.', 'Indústria', 'Equipe GIDIB', 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&q=80', array['Power BI', 'Dados', 'Indústria 4.0']::text[], array['Dashboards e relatórios em tempo real vêm se tornando parte essencial da rotina de gestores industriais.']::text[], '4 min de leitura', array[]::text[], 'published', '2026-09-10'),
  ('as-competencias-mais-valorizadas-na-industria-em-2027', 'As competências mais valorizadas na indústria em 2027', 'Conheça as habilidades técnicas e comportamentais que estão em alta entre os profissionais da indústria.', 'Carreira', 'Equipe GIDIB', 'https://images.unsplash.com/photo-1580894732444-8ecded7900cd?w=800&q=80', array['Carreira', 'Qualificação']::text[], array['O mercado industrial busca profissionais cada vez mais multidisciplinares.']::text[], '6 min de leitura', array[]::text[], 'published', '2026-09-08'),
  ('startups-que-estao-revolucionando-a-industria', 'Startups que estão revolucionando a indústria', 'Iniciativas inovadoras que estão trazendo novas soluções para os desafios da indústria brasileira.', 'Inovação', 'Equipe GIDIB', 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&q=80', array['Inovação', 'Startups']::text[], array['O ecossistema de inovação industrial no Brasil vem crescendo ano após ano.']::text[], '5 min de leitura', array[]::text[], 'published', '2026-09-05'),
  ('industria-verde-e-amarela-oportunidades-e-desafios', 'Indústria verde e amarela: oportunidades e desafios', 'Um panorama sobre a transição da indústria brasileira rumo a práticas mais sustentáveis.', 'Sustentabilidade', 'Equipe GIDIB', 'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=800&q=80', array['Sustentabilidade', 'ESG']::text[], array['A sustentabilidade se tornou um pilar estratégico para a indústria.']::text[], '4 min de leitura', array[]::text[], 'published', '2026-09-02'),
  ('evento-gidib-2026-inscricoes-abertas', 'Evento GIDIB 2026: inscrições abertas', 'Já estão abertas as inscrições para o maior encontro de inovação da indústria brasileira.', 'GIDIB', 'Equipe GIDIB', 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80', array['GIDIB', 'Eventos']::text[], array['O evento reunirá lideranças, especialistas e profissionais da indústria.']::text[], '3 min de leitura', array[]::text[], 'published', '2026-09-01')
on conflict (slug) do nothing;

insert into public.events (slug, title, description, modality, event_date, event_time, location, registration_url, status) values
  ('ia-aplicada-a-industria', 'IA aplicada à indústria', 'Tendências, aplicações e casos reais de uso de inteligência artificial no setor industrial.', 'Webinar', '2026-10-18', '19:00', 'Online', '#', 'published'),
  ('industria-4-0-na-pratica', 'Indústria 4.0 na prática', 'Ferramentas e estratégias para sua empresa iniciar a jornada da indústria 4.0.', 'Workshop', '2026-10-25', '09:00', 'São Paulo - SP', '#', 'published'),
  ('desenvolvimento-da-industria-brasileira', 'Desenvolvimento da Indústria Brasileira', 'Networking, palestras e cases de sucesso.', 'Encontro', '2026-11-08', '08:00', 'São Paulo - SP', '#', 'published'),
  ('manutencao-preditiva-com-iot', 'Manutenção preditiva com IoT', 'Como sensores e dados estão transformando a manutenção industrial.', 'Webinar', '2026-11-22', '19:00', 'Online', '#', 'published')
on conflict (slug) do nothing;

insert into public.projects (slug, title, description, category, image, sort_order) values
  ('industria-4-0-para-todos', 'Indústria 4.0 para todos', 'Programa de capacitação em tecnologias de automação e digitalização para profissionais da indústria.', 'Qualificação', 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=800&q=80', 0),
  ('mapa-da-inovacao-industrial', 'Mapa da Inovação Industrial', 'Levantamento e mapeamento de iniciativas inovadoras na indústria brasileira.', 'Inovação', 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&q=80', 1),
  ('industria-verde-e-amarela', 'Indústria Verde e Amarela', 'Iniciativa voltada para práticas sustentáveis e responsabilidade ambiental no setor industrial.', 'Sustentabilidade', 'https://images.unsplash.com/photo-1497435334941-8c899ee9e8e9?w=800&q=80', 2)
on conflict (slug) do nothing;

insert into public.partners (name, sort_order) values
  ('AXTENN', 0),
  ('HEXAGON Manufacturing Intelligence', 1),
  ('Mac 3D', 2),
  ('SmartPLM', 3),
  ('Robótica — Revista Técnico-Científica', 4),
  ('Surface Técnica', 5),
  ('Simples Soluções', 6),
  ('Ragna Soluções em Tecnologia', 7),
  ('NR12 Sem Segredos', 8),
  ('Peerdustry', 9),
  ('MCK Automação Industrial', 10),
  ('Oriai', 11),
  ('IBVT', 12),
  ('Exithum', 13),
  ('Discuta Lean 4.0', 14),
  ('Dalca Brasil', 15),
  ('AI Robots', 16),
  ('3D Inovabr', 17),
  ('Manufatura Inteligente', 18),
  ('Ladder Edge', 19),
  ('IMAM', 20),
  ('Atalog', 21),
  ('Comac', 22);
