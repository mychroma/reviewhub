-- Platforms
insert into platforms (name, category) values
  ('네이버','WEBTOON'),
  ('카카오','WEBTOON'),
  ('리디','WEBNOVEL'),
  ('카카오','WEBNOVEL'),
  ('라프텔','ANIME'),
  ('넷플릭스','ANIME')
  on conflict do nothing;

-- Works
insert into works (title, author, cover_url, category, genres, status) values
  ('전지적 독자 시점','싱숑',null,'WEBTOON',array['판타지','액션'],'ONGOING'),
  ('나 혼자만 레벨업','추공',null,'WEBTOON',array['판타지','액션'],'COMPLETED'),
  ('달빛 조각사','남희성',null,'WEBNOVEL',array['판타지','게임'],'COMPLETED'),
  ('귀멸의 칼날','ufotable',null,'ANIME',array['액션','어드벤처'],'ONGOING')
  on conflict do nothing;

-- Link works to platforms
insert into work_platforms (work_id, platform_id, platform_label)
select w.id, p.id, p.name
from works w
join platforms p
  on (w.category='WEBTOON' and p.category='WEBTOON' and p.name in ('네이버','카카오'))
  or (w.category='WEBNOVEL' and p.category='WEBNOVEL' and p.name in ('리디','카카오'))
  or (w.category='ANIME' and p.category='ANIME' and p.name in ('라프텔','넷플릭스'))
on conflict do nothing;
