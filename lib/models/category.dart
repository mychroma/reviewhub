enum ContentCategory { webtoon, webnovel, anime }

ContentCategory categoryFromDb(String value) {
  switch (value) {
    case 'WEBTOON':
      return ContentCategory.webtoon;
    case 'WEBNOVEL':
      return ContentCategory.webnovel;
    case 'ANIME':
      return ContentCategory.anime;
    default:
      return ContentCategory.webtoon;
  }
}

String categoryToDb(ContentCategory c) {
  switch (c) {
    case ContentCategory.webtoon:
      return 'WEBTOON';
    case ContentCategory.webnovel:
      return 'WEBNOVEL';
    case ContentCategory.anime:
      return 'ANIME';
  }
}
