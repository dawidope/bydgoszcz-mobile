import 'package:bydgoszcz/models/monument.dart';

class MonumentsRepository {
  List<Monument> getAllMonuments() {
    return [
      const Monument(
        id: 'wyspa_mlynska',
        name: 'Wyspa Młyńska',
        shortDescription: 'Zielone serce Bydgoszczy, otoczone wodami Brdy',
        facts:
            'Powstała w średniowieczu jako miejsce młynów wodnych. Dziś to jedna z najpiękniejszych zielonych przestrzeni w centrum miasta.',
        imageUrl: 'assets/monuments/wyspa_mlynska.jpg',
      ),
      const Monument(
        id: 'spichrze',
        name: 'Spichrze nad Brdą',
        shortDescription: 'Zabytkowe spichlerze z XIX wieku',
        facts:
            'Magazyny zbożowe z czerwonej cegły, które przypominają o znaczeniu Bydgoszczy jako ośrodka handlowego.',
        imageUrl: 'assets/monuments/spichrze.jpg',
      ),
      const Monument(
        id: 'katedra',
        name: 'Katedra św. Marcina i Mikołaja',
        shortDescription: 'Gotycka świątynia z XV wieku',
        facts:
            'Najstarsza i największa świątynia w Bydgoszczy, zbudowana w stylu gotyckim. Wewnątrz znajduje się piękny ołtarz główny.',
        imageUrl: 'assets/monuments/katedra.jpg',
      ),
      const Monument(
        id: 'mlyny_rothera',
        name: 'Młyny Rothera',
        shortDescription: 'Zabytkowy kompleks młynów przemysłowych',
        facts:
            'Jeden z najlepiej zachowanych kompleksów młynów wodnych w Europie, działający od XIX wieku.',
        imageUrl: 'assets/monuments/mlyny.jpg',
      ),
      const Monument(
        id: 'stary_rynek',
        name: 'Stary Rynek',
        shortDescription: 'Historyczne centrum miasta',
        facts:
            'Miejsce, gdzie biło serce starej Bydgoszczy. Otoczony kamieniczkami i pełen kawiarnianych ogródków.',
        imageUrl: 'assets/monuments/rynek.jpg',
      ),
      const Monument(
        id: 'przechodzacy',
        name: 'Przechodzący przez rzekę',
        shortDescription: 'Słynna rzeźba nad Brdą',
        facts:
            'Jedna z najfotografowanych rzeźb w Polsce, przedstawiająca ludzi przechodzących przez rzekę.',
        imageUrl: 'assets/monuments/przechodzacy.jpg',
      ),
      const Monument(
        id: 'muzeum_mydla',
        name: 'Muzeum Mydła i Historii Brudu',
        shortDescription: 'Unikalne muzeum poświęcone higienie',
        facts:
            'Jedyne takie muzeum w Polsce, pokazujące historię czystości i produkcji mydła.',
        imageUrl: 'assets/monuments/muzeum.jpg',
      ),
      const Monument(
        id: 'kanal_bydgoski',
        name: 'Kanał Bydgoski',
        shortDescription: 'Zabytkowy kanał wodny łączący Wisłę z Odrą',
        facts:
            'Najstarszy kanał żeglugowy w Polsce, zbudowany w XVIII wieku. Ma system śluz umożliwiających pokonanie różnic wysokości.',
        imageUrl: 'assets/monuments/kanal.jpg',
      ),
    ];
  }

  Monument? getMonumentById(String id) {
    try {
      return getAllMonuments().firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Monument> getMonumentsByIds(List<String> ids) {
    return getAllMonuments().where((m) => ids.contains(m.id)).toList();
  }
}
