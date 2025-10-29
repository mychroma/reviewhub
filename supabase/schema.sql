-- Enums
create type content_category as enum ('WEBTOON','WEBNOVEL','ANIME');
create type serialization_status as enum ('ONGOING','COMPLETED');

-- Platforms
create table if not exists platforms (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category content_category not null,
  unique(name, category)
);

-- Works (작품)
create table if not exists works (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  author text,
  cover_url text,
  category content_category not null,
  genres text[] default '{}',
  status serialization_status not null default 'ONGOING',
  created_at timestamptz not null default now()
);

-- Work ↔ Platform (N:N)
create table if not exists work_platforms (
  work_id uuid references works(id) on delete cascade,
  platform_id uuid references platforms(id) on delete cascade,
  platform_label text,
  primary key (work_id, platform_id)
);

-- Public aggregate ratings
create table if not exists work_ratings (
  work_id uuid primary key references works(id) on delete cascade,
  rating_count int not null default 0,
  rating_sum int not null default 0
);

-- Per-user progress
create table if not exists user_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  work_id uuid not null references works(id) on delete cascade,
  progress_text text,
  updated_at timestamptz not null default now(),
  primary key (user_id, work_id)
);

-- Reviews
create table if not exists reviews (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  work_id uuid not null references works(id) on delete cascade,
  rating int not null check (rating between 0 and 10),
  review_text text,
  tags text[] default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_reviews_work_id on reviews(work_id);
create index if not exists idx_reviews_user_work on reviews(user_id, work_id);

-- Triggers for aggregate ratings
create or replace function update_work_ratings_on_insert() returns trigger as $$
begin
  insert into work_ratings(work_id, rating_count, rating_sum)
  values (new.work_id, 1, new.rating)
  on conflict (work_id) do update
    set rating_count = work_ratings.rating_count + 1,
        rating_sum   = work_ratings.rating_sum + excluded.rating;
  return new;
end; $$ language plpgsql;

create or replace function update_work_ratings_on_update() returns trigger as $$
begin
  update work_ratings
    set rating_sum = rating_sum - old.rating + new.rating
  where work_id = new.work_id;
  return new;
end; $$ language plpgsql;

create or replace function update_work_ratings_on_delete() returns trigger as $$
begin
  update work_ratings
    set rating_count = rating_count - 1,
        rating_sum   = rating_sum - old.rating
  where work_id = old.work_id;
  return old;
end; $$ language plpgsql;

create trigger if not exists trg_reviews_insert after insert on reviews
for each row execute function update_work_ratings_on_insert();

create trigger if not exists trg_reviews_update after update of rating on reviews
for each row execute function update_work_ratings_on_update();

create trigger if not exists trg_reviews_delete after delete on reviews
for each row execute function update_work_ratings_on_delete();
