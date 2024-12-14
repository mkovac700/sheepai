import 'package:dart_web_scraper/dart_web_scraper.dart';

Future<Object> scrapeWebContent(String url) async {
  final webScraper = WebScraper();
  final result = await webScraper.scrape(
    url: Uri.parse(url),
    configMap: {
      'default': [
        Config(
          parsers: {
            'content': [
              Parser(
                id: 'html',
                parent: ['_root'],
                type: ParserType.element,
                selector: ['html'],
              ),
            ],
          },
          urlTargets: [
            UrlTarget(
              name: 'default',
              where: ['/'],
            ),
          ],
        ),
      ],
    },
    configIndex: 0,
    debug: true,
  );

  return result['html'] ?? '';
}
