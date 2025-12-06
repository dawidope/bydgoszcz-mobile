import 'package:bydgoszcz/models/monument.dart';

class MonumentsRepository {
  static final MonumentsRepository _instance = MonumentsRepository._internal();
  factory MonumentsRepository() => _instance;
  MonumentsRepository._internal();

  static const List<Monument> _monuments = [
    Monument(
      id: 'muzeum_mydla',
      name: 'Muzeum Mydła i Historii Brudu',
      shortDescription:
          'Jedno z najbardziej oryginalnych miejsc w Polsce. Zwiedzając je, odkryjesz, jak dawniej radzono sobie z higieną.',
      facts:
          'Muzeum Mydła i Historii Brudu to jedno z najbardziej oryginalnych miejsc w Polsce. Zwiedzając je, odkryjesz, jak dawniej radzono sobie z higieną, zobaczysz zabawne, czasami zaskakujące eksponaty, a przede wszystkim - samodzielnie zrobisz pachnące, kolorowe mydło. To muzeum pełne humoru, ciekawostek i interaktywnych atrakcji, idealne zarówno dla dzieci, jak i dorosłych. Wizyta tutaj to świetna zabawa, ale też lekcja historii codzienności, o której rzadko się opowiada. To obowiązkowy punkt bydgoskiego szlaku rodzinnego.',
      imageUrl: 'assets/images/muzeum_mydla.png',
      googleMapsUrl: 'https://maps.app.goo.gl/D26NPtUD2rtcZBEC8',
      audioUrl: 'assets/audio/muzeum_mydla.mp3',
    ),
    Monument(
      id: 'luczniczka',
      name: 'Rzeźba Łuczniczki',
      shortDescription:
          'Jedna z najbardziej rozpoznawalnych ikon Bydgoszczy. Symbol piękna, harmonii i siły.',
      facts:
          'Łuczniczka to jedna z najbardziej rozpoznawalnych ikon Bydgoszczy. Delikatna, elegancka postać kobiety napinającej łuk od ponad wieku zachwyca mieszkańców i turystów. To symbol piękna, harmonii i siły, a dla wielu - najpiękniejsza rzeźba miasta. Obecna przy Filharmonii Pomorskiej wersja jest rekonstrukcją oryginału z 1910 roku. Łuczniczka stała się także jednym z najczęściej fotografowanych miejsc w Bydgoszczy, a jej wizerunek pojawia się na plakatach, pamiątkach i materiałach promocyjnych miasta.',
      imageUrl: 'assets/images/luczniczka.png',
      googleMapsUrl: 'https://maps.app.goo.gl/bQNrUvyX61A49wJy8',
      audioUrl: 'assets/audio/luczniczka.mp3',
    ),
    Monument(
      id: 'przechodzacy_przez_rzeke',
      name: 'Przechodzący przez rzekę',
      shortDescription:
          'Spektakularna rzeźba balansująca nad Brdą na jednej stopie - bez lin, podpór czy widocznych mocowań.',
      facts:
          '„Przechodzący przez rzekę" to spektakularna rzeźba balansująca nad Brdą na jednej stopie - bez lin, podpór czy widocznych mocowań. Wygląda, jakby lekko unosił się nad wodą! Instalacja została odsłonięta w 2004 roku i od razu stała się symbolem nowoczesnej Bydgoszczy. Wykonana z brązu postać akrobaty symbolizuje równowagę między tradycją a współczesnością, pokazując odwagę miasta w tworzeniu rzeczy nieoczywistych. To jedno z najbardziej fotografowanych miejsc w centrum Bydgoszczy.',
      imageUrl: 'assets/images/przechodzacy_przez_rzeke.png',
      googleMapsUrl: 'https://maps.app.goo.gl/j3SDPaykrY1KAQ1WA',
      audioUrl: 'assets/audio/przechodzacy_przez_rzeke.mp3',
    ),
    Monument(
      id: 'mistrz_twardowski',
      name: 'Mistrz Twardowski - rzeźba',
      shortDescription:
          'Rzeźba nawiązująca do słynnej legendy o czarodzieju, który pojawił się w Bydgoszczy.',
      facts:
          'Rzeźba Mistrza Twardowskiego na ulicy Długiej nawiązuje do słynnej legendy o czarodzieju, który - jak głosi opowieść - naprawdę miał pojawić się w Bydgoszczy i wywołać tu serię magicznych zdarzeń. Brązowa figura, autorstwa Jerzego Kędziory, została odsłonięta w 2006 roku i od tego czasu wygląda tak, jakby właśnie wychylała się z okna, gotowa zaczepić przechodniów. To jedno z najbardziej lubianych i „instagramowych" miejsc w centrum miasta - idealne na pamiątkowe zdjęcie. Rzeźba przypomina o humorystycznym, baśniowym obliczu Bydgoszczy i dodaje starówce wyjątkowego uroku.',
      imageUrl: 'assets/images/mistrz_twardowski.png',
      googleMapsUrl: 'https://maps.app.goo.gl/jdukYWTzF8dtjUpJ9',
      audioUrl: 'assets/audio/mistrz_twardowski.mp3',
    ),
    Monument(
      id: 'kanal_bydgoski',
      name: 'Kanał Bydgoski',
      shortDescription:
          'Jedno z najstarszych sztucznych kanałów żeglugowych w Polsce, otwarty w XVIII wieku.',
      facts:
          'Kanał Bydgoski to jedno z najstarszych sztucznych kanałów żeglugowych w Polsce, otwarty w XVIII wieku. Łączył Wisłę z Odrą, dzięki czemu stał się kluczową drogą handlową i technicznym osiągnięciem swoich czasów. Dziś to spokojne, zielone miejsce idealne na spacery, jazdę rowerem i odkrywanie historycznych śluz, z których część działa do dziś. Kanał tworzy wyjątkowy klimat - połączenie historii inżynierii, natury i relaksu. To niezwykle malowniczy fragment Bydgoszczy.',
      imageUrl: 'assets/images/kanal_bydgoski.png',
      googleMapsUrl: 'https://maps.app.goo.gl/9MtZqL3ffK99BU9o9',
      audioUrl: 'assets/audio/kanal_bydgoski.mp3',
    ),
    Monument(
      id: 'fontanna_potop',
      name: 'Fontanna Potop',
      shortDescription:
          'Jedno z najważniejszych dzieł rzeźbiarskich w Polsce z 1904 roku.',
      facts:
          'Fontanna Potop to jedno z najważniejszych dzieł rzeźbiarskich w Polsce. Powstała w 1904 roku i przedstawia dramatyczny biblijny motyw ratowania się przed wielką wodą. Zniszczona po II wojnie światowej, została w pełni odrestaurowana i ponownie odsłonięta w 2014 roku. To monumentalne, pełne emocji dzieło, które przyciąga uwagę rozmachem, detalami i siłą przekazu. Stanowi jedną z najcenniejszych atrakcji na Placu Wolności i obowiązkowy punkt każdego spaceru po mieście.',
      imageUrl: 'assets/images/fontanna_potop.png',
      googleMapsUrl: 'https://maps.app.goo.gl/jSgnkVPtXNBF6w8K9',
      audioUrl: 'assets/audio/fontanna_potop.mp3',
    ),
    Monument(
      id: 'myslecinek',
      name: 'Myślęcinek - Leśny Park Kultury i Wypoczynku',
      shortDescription:
          'Największy park miejski w Polsce - ponad 800 hektarów zieleni, jezior i atrakcji.',
      facts:
          'Myślęcinek to największy park miejski w Polsce - ponad 800 hektarów zieleni, jezior, wzniesień i atrakcji dla całych rodzin. Znajdziesz tu ZOO, ogród botaniczny, park linowy, stoki narciarskie, wesołe miasteczko i dziesiątki ścieżek spacerowych oraz rowerowych. To idealne miejsce na odpoczynek, sport i aktywne spędzanie czasu. Myślęcinek jest zielonym sercem miasta i ulubioną przestrzenią weekendową bydgoszczan, oferując coś na każdą pogodę i dla każdego wieku.',
      imageUrl: 'assets/images/myslecinek.png',
      googleMapsUrl: 'https://maps.app.goo.gl/HJzTGBzjoEftCv5c7',
      audioUrl: 'assets/audio/myslecinek.mp3',
    ),
    Monument(
      id: 'wyspa_mlynska',
      name: 'Wyspa Młyńska',
      shortDescription:
          'Najbardziej malownicze miejsce w centrum Bydgoszczy, otoczone wodami Brdy.',
      facts:
          'Wyspa Młyńska to najbardziej malownicze miejsce w centrum Bydgoszczy. Otoczona wodami Brdy, pełna zabytków, kanałów i mostków, jest idealna na spacer, piknik i robienie zdjęć. To tu znajdują się Młyny Rothera, galerie muzealne i piękne przestrzenie rekreacyjne. Wyspa była przez wieki przemysłowym sercem miasta, dziś jest jego kulturalną wizytówką. Latem odbywają się tu koncerty i wydarzenia, a o każdej porze roku zachwyca atmosferą spokoju i elegancji.',
      imageUrl: 'assets/images/wyspa_mlynska.png',
      googleMapsUrl: 'https://maps.app.goo.gl/Wp4tsFqoTKW4MXYcA',
      audioUrl: 'assets/audio/wyspa_mlynska.mp3',
    ),
    Monument(
      id: 'wieza_cisnien',
      name: 'Wieża Ciśnień - Muzeum Wodociągów',
      shortDescription:
          'Jeden z najbardziej charakterystycznych punktów panoramy Bydgoszczy z 1900 roku.',
      facts:
          'Wieża Ciśnień z 1900 roku to jeden z najbardziej charakterystycznych punktów panoramy Bydgoszczy. Dziś mieści się w niej Muzeum Wodociągów, które w ciekawy sposób opowiada o historii miejskich instalacji i życiu dawnych bydgoszczan. Największą atrakcją jest taras widokowy na szczycie - panorama miasta z tego miejsca wygląda obłędnie. To idealny punkt, by zobaczyć Bydgoszcz z zupełnie innej perspektywy.',
      imageUrl: 'assets/images/wieza_cisnien.png',
      googleMapsUrl: 'https://maps.app.goo.gl/fgaNh9GCCg9kdjNKA',
      audioUrl: 'assets/audio/wieza_cisnien.mp3',
    ),
    Monument(
      id: 'katedra_bydgoska',
      name: 'Katedra Bydgoska (Katedra św. Marcina i Mikołaja)',
      shortDescription:
          'Gotycki kościół z XV wieku i jeden z najważniejszych zabytków sakralnych regionu.',
      facts:
          'Katedra Bydgoska to gotycki kościół z XV wieku i jeden z najważniejszych zabytków sakralnych regionu. W środku zachwyca bogatymi polichromiami, barokowym ołtarzem i wyjątkowym obrazem Matki Boskiej Pięknej Miłości - patronki miasta. Katedra stoi tu, gdzie zaczęła się historia Bydgoszczy, tuż przy rzece Brdzie. To miejsce pełne spokoju, historii i pięknej architektury, które warto zobaczyć zarówno w dzień, jak i wieczorem, gdy okolica jest nastrojowo oświetlona.',
      imageUrl: 'assets/images/katedra_bydgoska.png',
      googleMapsUrl: 'https://maps.app.goo.gl/7NoyRLbXU95hegfA6',
      audioUrl: 'assets/audio/katedra_bydgoska.mp3',
    ),
    Monument(
      id: 'mlyny_rothera',
      name: 'Młyny Rothera',
      shortDescription:
          'Imponujący kompleks przemysłowy z około 1850 roku, dziś centrum kultury i nauki.',
      facts:
          'Młyny Rothera to imponujący kompleks przemysłowy z około 1850 roku, stojący w samym sercu Wyspy Młyńskiej. Dawniej były potężnymi magazynami zbożowymi i jednym z najważniejszych punktów przemysłowych Bydgoszczy. Dziś - po spektakularnej rewitalizacji - stały się nowoczesnym centrum kultury, nauki i spotkań. W środku znajdziesz interaktywne wystawy, wydarzenia, kreatywne przestrzenie i piękne wnętrza, które łączą industrialny klimat z nowoczesnym designem. To jedno z najbardziej wyjątkowych i inspirujących miejsc na mapie miasta.',
      imageUrl: 'assets/images/mlyny_rothera.png',
      googleMapsUrl: 'https://maps.app.goo.gl/nwFaUZgnTGA6oxEK6',
      audioUrl: 'assets/audio/mlyny_rothera.mp3',
    ),
    Monument(
      id: 'stadion_zawiszy',
      name: 'Stadion Zawiszy Bydgoszcz',
      shortDescription:
          'Sportowe serce Bydgoszczy, znane z międzynarodowych zawodów lekkoatletycznych.',
      facts:
          'Stadion Zawiszy to sportowe serce Bydgoszczy, znane z organizacji międzynarodowych zawodów lekkoatletycznych, meczów piłkarskich i wydarzeń masowych. Nowoczesny obiekt otoczony zielenią Myślęcinka pomieści kilkanaście tysięcy widzów, a jego bieżnia jest uznawana za jedną z najlepszych w Polsce. To miejsce pełne sportowych emocji, rekordów, rywalizacji i niezapomnianych chwil dla kibiców oraz mieszkańców.',
      imageUrl: 'assets/images/stadion_zawiszy.png',
      googleMapsUrl: 'https://maps.app.goo.gl/Q4hLdgbDyCXdM2gG7',
      audioUrl: 'assets/audio/stadion_zawiszy.mp3',
    ),
    Monument(
      id: 'muzeum_wojsk_ladowych',
      name: 'Muzeum Wojsk Lądowych w Bydgoszczy',
      shortDescription:
          'Jedno z najważniejszych miejsc w Polsce poświęconych historii wojska i obronności.',
      facts:
          'Muzeum Wojsk Lądowych to jedno z najważniejszych miejsc w Polsce poświęconych historii wojska i obronności. Znajdziesz tu imponujące ekspozycje broni, umundurowania, pojazdów i sprzętu wojskowego - od czasów średniowiecza po współczesność. Wystawy pozwalają zobaczyć, jak zmieniały się technika, taktyka i codzienne życie żołnierzy na przestrzeni wieków. To miejsce pełne autentycznych artefaktów i ciekawych opowieści, idealne dla miłośników historii, techniki i militariów. Wizyta tutaj to żywa lekcja polskiej wojskowości i odkrywanie jej najciekawszych momentów.',
      imageUrl: 'assets/images/muzeum_wojsk_ladowych.png',
      googleMapsUrl: 'https://maps.app.goo.gl/FkbfXrYMgH1ycd618',
      audioUrl: 'assets/audio/muzeum_wojsk_ladowych.mp3',
    ),
  ];

  List<Monument> getAllMonuments() {
    return _monuments;
  }

  Monument? getMonumentById(String id) {
    try {
      return _monuments.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Monument> getMonumentsByIds(List<String> ids) {
    return _monuments.where((m) => ids.contains(m.id)).toList();
  }

  List<Monument> searchMonuments(String query) {
    final lowerQuery = query.toLowerCase();
    return _monuments
        .where(
          (m) =>
              m.name.toLowerCase().contains(lowerQuery) ||
              m.shortDescription.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }
}
