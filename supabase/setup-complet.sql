-- Arène Icademie : schéma Supabase. À coller dans SQL Editor > New query > Run.

create table if not exists public.notions (
  id text primary key,
  notion text not null,
  module text not null,
  etape int default 1,
  chapitre text,
  epreuve text,
  fiche boolean default false
);

create table if not exists public.sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  at timestamptz not null default now(),
  date date not null default current_date,
  mode text,
  titre text,
  boss text,
  victoire boolean,
  combo int default 0,
  carte text,
  source text not null default 'arene'
);

create table if not exists public.reponses (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  session_id uuid references public.sessions(id) on delete cascade,
  date date not null,
  seance text,
  question text,
  notion text not null,
  correct boolean not null,
  given text,
  attendu text,
  source text not null default 'arene',
  created_at timestamptz not null default now()
);
create index if not exists reponses_user_idx on public.reponses(user_id, date);

create table if not exists public.profil (
  user_id uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  titre text,
  updated_at timestamptz default now()
);

alter table public.notions enable row level security;
alter table public.sessions enable row level security;
alter table public.reponses enable row level security;
alter table public.profil enable row level security;

drop policy if exists "notions lisibles" on public.notions;
create policy "notions lisibles" on public.notions for select using (true);

drop policy if exists "mes sessions" on public.sessions;
create policy "mes sessions" on public.sessions for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "mes reponses" on public.reponses;
create policy "mes reponses" on public.reponses for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "mon profil" on public.profil;
create policy "mon profil" on public.profil for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

insert into public.notions (id,notion,module,etape,chapitre,epreuve,fiche) values
('demonstratifs','This / these / that / those','Anglais UCB 31',1,'Basic grammar','Écrit – QCM grammaire',true),
('some-any-no','Some / any / no','Anglais UCB 31',1,'Basic grammar','Écrit – QCM grammaire',true),
('articles','Articles a / an / the / Ø','Anglais UCB 31',1,'Basic grammar','Écrit – QCM grammaire',true),
('present-simple-continu','Présent simple ou continu','Anglais UCB 31',1,'Le présent','Écrit – QCM grammaire',true),
('3e-personne-does','-s de la 3e personne et does','Anglais UCB 31',1,'Le présent','Écrit – QCM grammaire',true),
('verbes-etat','Verbes d''opinion au présent simple','Anglais UCB 31',1,'Le présent','Écrit – QCM grammaire',true),
('preterit','Prétérit (passé simple)','Anglais UCB 31',1,'Passé et futur','Écrit – QCM grammaire',true),
('present-perfect','Present perfect','Anglais UCB 31',1,'Passé et futur','Écrit – QCM grammaire',true),
('plu-perfect','Plus-que-parfait (had + participe)','Anglais UCB 31',1,'Passé et futur','Écrit – QCM grammaire',true),
('futur','Futur : will / be going to','Anglais UCB 31',1,'Passé et futur','Écrit – QCM grammaire',true),
('comparatifs','Comparatifs et superlatifs','Anglais UCB 31',2,'Comparative and Superlative','Écrit – QCM grammaire',false),
('gerondif-infinitif','Gérondif ou infinitif','Anglais UCB 31',2,'Gerund or Infinitive','Écrit – QCM grammaire',false),
('modaux','Verbes modaux','Anglais UCB 31',2,'Modal verbs and conditional','Écrit – QCM grammaire',false),
('conditionnel','Conditionnel','Anglais UCB 31',2,'Modal verbs and conditional','Écrit – QCM grammaire',false),
('faux-amis','Faux amis et erreurs fréquentes','Anglais UCB 31',3,'False Friends','Écrit – QCM lexique',false),
('mail-structure','Structure d''un mail professionnel','Anglais UCB 31',4,'How to write emails','Écrit – production (28 pts)',false),
('mail-formules','Formules et expressions des mails','Anglais UCB 31',4,'Vocabulary for emails','Écrit – production (28 pts)',false),
('netiquette','(N)Etiquette','Anglais UCB 31',4,'(N)Etiquette','Écrit – production (28 pts)',false),
('se-presenter','Se présenter','Anglais UCB 31',5,'Presenting yourself','Oral – entretien',false),
('presenter-entreprise','Présenter son entreprise et son alternance','Anglais UCB 31',5,'Presenting a company','Oral – entretien',false),
('comprendre-article','Comprendre un article','Anglais UCB 31',6,'How to understand an article','Écrit – compréhension',false),
('vocab-presse','Vocabulaire de la presse','Anglais UCB 31',6,'The press','Oral – médiation',false),
('vocab-marketing','Vocabulaire marketing et vente','Anglais UCB 31',7,'Vocabulaire Marketing et Vente','Écrit – QCM lexique',false),
('vocab-rh','Vocabulaire RH','Anglais UCB 31',7,'Vocabulaire RH','Écrit – QCM lexique',false),
('vocab-finance','Vocabulaire banque, finance, assurance','Anglais UCB 31',7,'Vocabulaire BFA','Écrit – QCM lexique',false),
('lecture-textes','Lire des textes type examen','Anglais UCB 31',8,'Reading Corner / HR','Écrit – compréhension',false),
('decrire-image','Décrire une image ou un graphique','Anglais UCB 31',8,'Oral – document iconographique','Oral – document',false),
('donner-avis','Donner et justifier son avis','Anglais UCB 31',8,'Oral – document iconographique','Oral – document',false),
('lx-produit','Laniflex : le produit','Anglais UCB 31',7,'Anglais pro Laniflex','Oral – entretien',false),
('lx-arguments','Laniflex : arguments de vente','Anglais UCB 31',7,'Anglais pro Laniflex','Oral – entretien',false),
('lx-client','Laniflex : client et devis','Anglais UCB 31',7,'Anglais pro Laniflex','Écrit – production (28 pts)',false),
('fr-a-a','a / à','Français',1,'Homophones','Écrits professionnels',false),
('fr-et-est','et / est · ou / où','Français',1,'Homophones','Écrits professionnels',false),
('fr-ces-ses','ces / ses / c''est / s''est','Français',1,'Homophones','Écrits professionnels',false),
('fr-son-sont','son / sont · on / ont','Français',1,'Homophones','Écrits professionnels',false),
('fr-e-er','-é ou -er','Français',2,'Verbes','Écrits professionnels',false),
('fr-pp-accord','Accord du participe passé','Français',2,'Verbes','Écrits professionnels',false),
('fr-futur-cond','Futur ou conditionnel (-rai / -rais)','Français',2,'Verbes','Écrits professionnels',false),
('fr-accord-verbe','Accord sujet / verbe','Français',2,'Verbes','Écrits professionnels',false),
('fr-mail-pro','Le mail professionnel','Français',3,'Écrit pro','Écrits professionnels',false),
('eu-histoire','Construction européenne','UC A2 Le projet européen',1,'Construction européenne','Examen écrit',false),
('eu-conseil','Le Conseil de l''Europe','UC A2 Le projet européen',1,'Le Conseil de l''Europe','Examen écrit',false),
('eu-frontieres','UE et frontières (Schengen)','UC A2 Le projet européen',1,'UE et frontières (Schengen)','Examen écrit',false),
('eu-relations','Relations extérieures de l''UE','UC A2 Le projet européen',1,'Relations extérieures de l''UE','Examen écrit',false),
('eu-orgs','Organisations internationales','UC A2 Le projet européen',1,'Organisations internationales','Examen écrit',false),
('eu-citoyennete','Citoyenneté européenne','UC A2 Le projet européen',1,'Citoyenneté européenne','Examen écrit',false),
('eu-institutions','Institutions de l''UE','UC A2 Le projet européen',1,'Institutions de l''UE','Examen écrit',false),
('eu-competences','Compétences de l''UE','UC A2 Le projet européen',1,'Compétences de l''UE','Examen écrit',false),
('eu-corruption','La corruption','UC A2 Le projet européen',1,'La corruption','Examen écrit',false),
('a3-culture','Culture et diversité culturelle','UC A3 Management interculturel',1,'Culture et diversité culturelle','Examen écrit',false),
('a3-communication','Communication interculturelle','UC A3 Management interculturel',1,'Communication interculturelle','Examen écrit',false),
('a3-diversite','Gérer la diversité et les conflits','UC A3 Management interculturel',1,'Gérer la diversité et les conflits','Examen écrit',false),
('a3-travail','Droit du travail et mobilité UE','UC A3 Management interculturel',1,'Droit du travail et mobilité UE','Examen écrit',false),
('a3-protection','Protection sociale','UC A3 Management interculturel',1,'Protection sociale','Examen écrit',false),
('a3-rse','RSE','UC A3 Management interculturel',1,'RSE','Examen écrit',false),
('a3-inclusion','Politiques d''inclusion','UC A3 Management interculturel',1,'Politiques d''inclusion','Examen écrit',false),
('ucd-strategie','Niveaux de stratégie, Canvas, DAS','UCD 31 Stratégie commerciale',1,'Niveaux de stratégie, Canvas, DAS','Examen écrit',false),
('ucd-audit','Audit commercial','UCD 31 Stratégie commerciale',1,'Audit commercial','Examen écrit',false),
('ucd-analyse','Veille et analyse (PESTEL, SWOT, Porter)','UCD 31 Stratégie commerciale',1,'Veille et analyse (PESTEL, SWOT, Porter)','Examen écrit',false),
('ucd-clients','Clients : persona, ABC, RFM','UCD 31 Stratégie commerciale',1,'Clients : persona, ABC, RFM','Examen écrit',false),
('ucd-objectifs','Objectifs SMART et PAC','UCD 31 Stratégie commerciale',1,'Objectifs SMART et PAC','Examen écrit',false),
('ucd-kpi','KPI, ROI, écarts','UCD 31 Stratégie commerciale',1,'KPI, ROI, écarts','Examen écrit',false),
('ucd-amelioration','Amélioration continue (PDCA, DMAIC)','UCD 31 Stratégie commerciale',1,'Amélioration continue (PDCA, DMAIC)','Examen écrit',false),
('ucd-droit','Droit commercial et RGPD','UCD 31 Stratégie commerciale',1,'Droit commercial et RGPD','Examen écrit',false),
('ucd-management','Management d''équipe','UCD 31 Stratégie commerciale',1,'Management d''équipe','Examen écrit',false),
('ucd-relation','Relation client','UCD 31 Stratégie commerciale',1,'Relation client','Examen écrit',false)
on conflict (id) do update set notion=excluded.notion,module=excluded.module,etape=excluded.etape,chapitre=excluded.chapitre,epreuve=excluded.epreuve,fiche=excluded.fiche;
