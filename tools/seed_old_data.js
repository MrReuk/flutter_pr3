const BASE = process.argv[2] || 'http://localhost:8080/api';
const USER = process.argv[3] || 'admin';
const PASSWORD = process.argv[4] || 'admin123';

const data = {
 "genres": [
  {
   "id": 1,
   "name": "Манга",
   "description": "Японские комиксы: сёнэн, сэйнэн и другие направления."
  },
  {
   "id": 2,
   "name": "Фэнтези",
   "description": "Вымышленные миры, магия и приключения."
  },
  {
   "id": 3,
   "name": "Финансы",
   "description": "Деньги, инвестиции и финансовая грамотность."
  },
  {
   "id": 4,
   "name": "Саморазвитие",
   "description": "Привычки, продуктивность и личная эффективность."
  },
  {
   "id": 5,
   "name": "Психология",
   "description": "Поведение людей, влияние и убеждение."
  },
  {
   "id": 6,
   "name": "Контркультура",
   "description": "Романы о людях на границе общепринятых норм."
  },
  {
   "id": 7,
   "name": "Приключения",
   "description": "Путешествия и открытия неизведанного."
  },
  {
   "id": 8,
   "name": "Хоррор",
   "description": "Мрачные истории о страхе и насилии."
  },
  {
   "id": 9,
   "name": "Постапокалипсис",
   "description": "Мир после глобальной катастрофы."
  }
 ],
 "publishers": [
  {
   "id": 1,
   "name": "Истари Комикс",
   "city": "Москва",
   "foundedYear": 2013
  },
  {
   "id": 2,
   "name": "Попурри",
   "city": "Минск",
   "foundedYear": 1991
  },
  {
   "id": 3,
   "name": "МИФ",
   "city": "Москва",
   "foundedYear": 2005
  },
  {
   "id": 4,
   "name": "АСТ",
   "city": "Москва",
   "foundedYear": 1990
  },
  {
   "id": 5,
   "name": "Бомбора",
   "city": "Москва",
   "foundedYear": 2016
  },
  {
   "id": 6,
   "name": "Питер",
   "city": "Санкт-Петербург",
   "foundedYear": 1991
  },
  {
   "id": 7,
   "name": "Амфора",
   "city": "Санкт-Петербург",
   "foundedYear": 1996
  },
  {
   "id": 8,
   "name": "Рипол Классик",
   "city": "Москва",
   "foundedYear": 1992
  }
 ],
 "authors": [
  {
   "id": 1,
   "fullName": "Миура Кэнтаро",
   "birthYear": 1966,
   "country": "Япония"
  },
  {
   "id": 2,
   "fullName": "Ода Эйитиро",
   "birthYear": 1975,
   "country": "Япония"
  },
  {
   "id": 3,
   "fullName": "Исида Суи",
   "birthYear": 1986,
   "country": "Япония"
  },
  {
   "id": 4,
   "fullName": "Аракава Хирому",
   "birthYear": 1973,
   "country": "Япония"
  },
  {
   "id": 5,
   "fullName": "Кубо Тите",
   "birthYear": 1977,
   "country": "Япония"
  },
  {
   "id": 6,
   "fullName": "Готогэ Коёхару",
   "birthYear": 1989,
   "country": "Япония"
  },
  {
   "id": 7,
   "fullName": "Фудзимото Тацуки",
   "birthYear": 1992,
   "country": "Япония"
  },
  {
   "id": 8,
   "fullName": "Цукуси Акихито",
   "birthYear": 1981,
   "country": "Япония"
  },
  {
   "id": 9,
   "fullName": "Кийосаки Роберт",
   "birthYear": 1947,
   "country": "США"
  },
  {
   "id": 10,
   "fullName": "Клир Джеймс",
   "birthYear": 1986,
   "country": "США"
  },
  {
   "id": 11,
   "fullName": "Мэнсон Марк",
   "birthYear": 1984,
   "country": "США"
  },
  {
   "id": 12,
   "fullName": "Хилл Наполеон",
   "birthYear": 1883,
   "country": "США"
  },
  {
   "id": 13,
   "fullName": "Грин Роберт",
   "birthYear": 1959,
   "country": "США"
  },
  {
   "id": 14,
   "fullName": "Карнеги Дейл",
   "birthYear": 1888,
   "country": "США"
  },
  {
   "id": 15,
   "fullName": "Чалдини Роберт",
   "birthYear": 1945,
   "country": "США"
  },
  {
   "id": 16,
   "fullName": "Паланик Чак",
   "birthYear": 1962,
   "country": "США"
  },
  {
   "id": 17,
   "fullName": "Буковски Чарльз",
   "birthYear": 1920,
   "country": "США"
  },
  {
   "id": 18,
   "fullName": "Глуховский Дмитрий",
   "birthYear": 1979,
   "country": "Россия"
  },
  {
   "id": 19,
   "fullName": "Сапковский Анджей",
   "birthYear": 1948,
   "country": "Польша"
  },
  {
   "id": 20,
   "fullName": "Ньюпорт Кал",
   "birthYear": 1982,
   "country": "США"
  }
 ],
 "books": [
  {
   "id": 1,
   "title": "Берсерк. Том 1",
   "isbn": "978-5-6040-0001-1",
   "year": 1990,
   "pages": 224,
   "publisherId": 1,
   "authorIds": [
    1
   ],
   "genreIds": [
    1,
    2
   ],
   "copiesTotal": 6,
   "copiesAvailable": 4
  },
  {
   "id": 2,
   "title": "Ван-Пис. Том 1",
   "isbn": "978-5-6040-0002-8",
   "year": 1997,
   "pages": 208,
   "publisherId": 1,
   "authorIds": [
    2
   ],
   "genreIds": [
    1,
    7
   ],
   "copiesTotal": 8,
   "copiesAvailable": 5
  },
  {
   "id": 3,
   "title": "Токийский гуль. Том 1",
   "isbn": "978-5-6040-0003-5",
   "year": 2011,
   "pages": 224,
   "publisherId": 1,
   "authorIds": [
    3
   ],
   "genreIds": [
    1,
    8
   ],
   "copiesTotal": 5,
   "copiesAvailable": 2
  },
  {
   "id": 4,
   "title": "Стальной алхимик. Том 1",
   "isbn": "978-5-17-100004-2",
   "year": 2001,
   "pages": 192,
   "publisherId": 4,
   "authorIds": [
    4
   ],
   "genreIds": [
    1,
    2
   ],
   "copiesTotal": 4,
   "copiesAvailable": 4
  },
  {
   "id": 5,
   "title": "Блич. Том 1",
   "isbn": "978-5-17-100005-9",
   "year": 2001,
   "pages": 192,
   "publisherId": 4,
   "authorIds": [
    5
   ],
   "genreIds": [
    1,
    2
   ],
   "copiesTotal": 4,
   "copiesAvailable": 3
  },
  {
   "id": 6,
   "title": "Клинок, рассекающий демонов. Том 1",
   "isbn": "978-5-6040-0006-6",
   "year": 2016,
   "pages": 192,
   "publisherId": 1,
   "authorIds": [
    6
   ],
   "genreIds": [
    1,
    2
   ],
   "copiesTotal": 7,
   "copiesAvailable": 6
  },
  {
   "id": 7,
   "title": "Человек-бензопила. Том 1",
   "isbn": "978-5-6040-0007-3",
   "year": 2018,
   "pages": 192,
   "publisherId": 1,
   "authorIds": [
    7
   ],
   "genreIds": [
    1,
    8
   ],
   "copiesTotal": 6,
   "copiesAvailable": 1
  },
  {
   "id": 8,
   "title": "Созданный в Бездне. Том 1",
   "isbn": "978-5-17-100008-0",
   "year": 2012,
   "pages": 160,
   "publisherId": 4,
   "authorIds": [
    8
   ],
   "genreIds": [
    1,
    7
   ],
   "copiesTotal": 3,
   "copiesAvailable": 3
  },
  {
   "id": 9,
   "title": "Богатый папа, бедный папа",
   "isbn": "978-985-15-0009-7",
   "year": 1997,
   "pages": 336,
   "publisherId": 2,
   "authorIds": [
    9
   ],
   "genreIds": [
    3,
    4
   ],
   "copiesTotal": 10,
   "copiesAvailable": 6
  },
  {
   "id": 10,
   "title": "Квадрант денежного потока",
   "isbn": "978-985-15-0010-3",
   "year": 1998,
   "pages": 368,
   "publisherId": 2,
   "authorIds": [
    9
   ],
   "genreIds": [
    3
   ],
   "copiesTotal": 5,
   "copiesAvailable": 5
  },
  {
   "id": 11,
   "title": "Атомные привычки",
   "isbn": "978-5-00146-011-4",
   "year": 2018,
   "pages": 320,
   "publisherId": 3,
   "authorIds": [
    10
   ],
   "genreIds": [
    4
   ],
   "copiesTotal": 9,
   "copiesAvailable": 3
  },
  {
   "id": 12,
   "title": "Тонкое искусство пофигизма",
   "isbn": "978-5-04-100012-1",
   "year": 2016,
   "pages": 224,
   "publisherId": 5,
   "authorIds": [
    11
   ],
   "genreIds": [
    4,
    5
   ],
   "copiesTotal": 6,
   "copiesAvailable": 2
  },
  {
   "id": 13,
   "title": "Думай и богатей",
   "isbn": "978-985-15-0013-4",
   "year": 1937,
   "pages": 336,
   "publisherId": 2,
   "authorIds": [
    12
   ],
   "genreIds": [
    3,
    4
   ],
   "copiesTotal": 5,
   "copiesAvailable": 4
  },
  {
   "id": 14,
   "title": "48 законов власти",
   "isbn": "978-5-386-10014-8",
   "year": 1998,
   "pages": 640,
   "publisherId": 8,
   "authorIds": [
    13
   ],
   "genreIds": [
    5
   ],
   "copiesTotal": 4,
   "copiesAvailable": 1
  },
  {
   "id": 15,
   "title": "Как завоёвывать друзей и оказывать влияние на людей",
   "isbn": "978-985-15-0015-8",
   "year": 1936,
   "pages": 352,
   "publisherId": 2,
   "authorIds": [
    14
   ],
   "genreIds": [
    4,
    5
   ],
   "copiesTotal": 6,
   "copiesAvailable": 5
  },
  {
   "id": 16,
   "title": "Психология влияния",
   "isbn": "978-5-496-00016-5",
   "year": 1984,
   "pages": 336,
   "publisherId": 6,
   "authorIds": [
    15
   ],
   "genreIds": [
    5
   ],
   "copiesTotal": 4,
   "copiesAvailable": 4
  },
  {
   "id": 17,
   "title": "Бойцовский клуб",
   "isbn": "978-5-17-100017-2",
   "year": 1996,
   "pages": 288,
   "publisherId": 4,
   "authorIds": [
    16
   ],
   "genreIds": [
    6
   ],
   "copiesTotal": 5,
   "copiesAvailable": 3
  },
  {
   "id": 18,
   "title": "Почтамт",
   "isbn": "978-5-367-00018-9",
   "year": 1971,
   "pages": 288,
   "publisherId": 7,
   "authorIds": [
    17
   ],
   "genreIds": [
    6
   ],
   "copiesTotal": 3,
   "copiesAvailable": 2
  },
  {
   "id": 19,
   "title": "Метро 2033",
   "isbn": "978-5-17-100019-6",
   "year": 2005,
   "pages": 544,
   "publisherId": 4,
   "authorIds": [
    18
   ],
   "genreIds": [
    9
   ],
   "copiesTotal": 8,
   "copiesAvailable": 5
  },
  {
   "id": 20,
   "title": "Ведьмак. Последнее желание",
   "isbn": "978-5-17-100020-2",
   "year": 1993,
   "pages": 352,
   "publisherId": 4,
   "authorIds": [
    19
   ],
   "genreIds": [
    2
   ],
   "copiesTotal": 7,
   "copiesAvailable": 4
  },
  {
   "id": 21,
   "title": "Ведьмак. Меч предназначения",
   "isbn": "978-5-17-100021-9",
   "year": 1992,
   "pages": 384,
   "publisherId": 4,
   "authorIds": [
    19
   ],
   "genreIds": [
    2
   ],
   "copiesTotal": 6,
   "copiesAvailable": 6
  },
  {
   "id": 22,
   "title": "Ведьмак. Кровь эльфов",
   "isbn": "978-5-17-100022-6",
   "year": 1994,
   "pages": 384,
   "publisherId": 4,
   "authorIds": [
    19
   ],
   "genreIds": [
    2
   ],
   "copiesTotal": 6,
   "copiesAvailable": 3
  },
  {
   "id": 23,
   "title": "Метро 2034",
   "isbn": "978-5-17-100023-3",
   "year": 2009,
   "pages": 384,
   "publisherId": 4,
   "authorIds": [
    18
   ],
   "genreIds": [
    9
   ],
   "copiesTotal": 5,
   "copiesAvailable": 5
  },
  {
   "id": 24,
   "title": "Глубокая работа",
   "isbn": "978-5-00146-024-4",
   "year": 2016,
   "pages": 296,
   "publisherId": 3,
   "authorIds": [
    20
   ],
   "genreIds": [
    4
   ],
   "copiesTotal": 4,
   "copiesAvailable": 0
  },
  {
   "id": 25,
   "title": "Богатый папа. Руководство по инвестированию",
   "isbn": "978-985-15-0025-7",
   "year": 2000,
   "pages": 400,
   "publisherId": 2,
   "authorIds": [
    9
   ],
   "genreIds": [
    3
   ],
   "copiesTotal": 4,
   "copiesAvailable": 2
  },
  {
   "id": 26,
   "title": "Берсерк. Том 2",
   "isbn": "978-5-6040-0026-4",
   "year": 1990,
   "pages": 224,
   "publisherId": 1,
   "authorIds": [
    1
   ],
   "genreIds": [
    1,
    2
   ],
   "copiesTotal": 6,
   "copiesAvailable": 5
  }
 ],
 "readers": [
  {
   "fullName": "Волков Артём",
   "email": "volkov.artem@example.com",
   "phone": "+7 900 111-22-01"
  },
  {
   "fullName": "Смирнова Дарья",
   "email": "smirnova.darya@example.com",
   "phone": "+7 900 111-22-02"
  },
  {
   "fullName": "Кузнецов Максим",
   "email": "kuznetsov.maxim@example.com",
   "phone": "+7 900 111-22-03"
  },
  {
   "fullName": "Попова Алиса",
   "email": "popova.alisa@example.com",
   "phone": "+7 900 111-22-04"
  },
  {
   "fullName": "Лебедев Кирилл",
   "email": "lebedev.kirill@example.com",
   "phone": "+7 900 111-22-05"
  },
  {
   "fullName": "Соколова Мария",
   "email": "sokolova.maria@example.com",
   "phone": "+7 900 111-22-06"
  },
  {
   "fullName": "Новиков Егор",
   "email": "novikov.egor@example.com",
   "phone": "+7 900 111-22-07"
  },
  {
   "fullName": "Морозова Полина",
   "email": "morozova.polina@example.com",
   "phone": "+7 900 111-22-08"
  },
  {
   "fullName": "Орлов Никита",
   "email": "orlov.nikita@example.com",
   "phone": "+7 900 111-22-09"
  },
  {
   "fullName": "Белова София",
   "email": "belova.sofia@example.com",
   "phone": "+7 900 111-22-10"
  }
 ]
};

const lecture = {
 "isbns": [
  "978-5-17-118366-4",
  "978-5-17-090620-1",
  "978-5-389-06003-6",
  "978-5-389-07773-7",
  "978-5-04-089115-8",
  "978-5-17-084362-9",
  "978-5-17-088237-6",
  "978-5-17-096909-1",
  "978-5-17-095832-3",
  "978-5-17-097584-9",
  "978-5-17-080115-5",
  "978-5-17-097584-1",
  "978-5-04-004643-9",
  "978-5-04-089116-5",
  "978-5-04-093471-6",
  "978-5-17-088179-9",
  "978-5-17-088180-5",
  "978-5-17-088181-2",
  "978-5-4461-0772-8",
  "978-5-4461-0906-7"
 ],
 "authors": [
  "Толстой Л. Н.",
  "Достоевский Ф. М.",
  "Булгаков М. А.",
  "Стругацкий А. Н.",
  "Стругацкий Б. Н.",
  "Оруэлл Дж.",
  "Брэдбери Р.",
  "Ремарк Э. М."
 ],
 "genres": [
  "Роман",
  "Фантастика",
  "Классика",
  "Антиутопия",
  "Детектив",
  "Техническая литература"
 ],
 "publishers": [
  "Эксмо",
  "Азбука"
 ],
 "emails": [
  "smirnov@example.com",
  "kuznetsova@example.com",
  "popov@example.com",
  "vasileva@example.com",
  "novikov@example.com",
  "morozova@example.com"
 ]
};

let token = '';

async function call(method, path, body) {
  const response = await fetch(BASE + path, {
    method,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: 'Bearer ' + token } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await response.text();
  const json = text ? JSON.parse(text) : null;
  if (!response.ok) {
    throw new Error(method + ' ' + path + ' -> ' + response.status + ' ' + text);
  }
  return json;
}

async function all(path) {
  const rows = [];
  for (let page = 1; ; page++) {
    const result = await call('GET', path + '?includeDeleted=true&page=' + page + '&size=100');
    rows.push(...result.items);
    if (page >= result.totalPages) return rows;
  }
}

async function purge(path, rows) {
  for (const row of rows) {
    await call('DELETE', path + '/' + row.id + '?hard=true');
  }
  console.log(path.padEnd(11), 'удалено:', rows.length);
}

async function removeLectureData() {
  const books = (await all('/books')).filter((x) => lecture.isbns.includes(x.isbn));
  const readers = (await all('/readers')).filter((x) => lecture.emails.includes(x.email));
  const bookIds = new Set(books.map((x) => x.id));
  const readerIds = new Set(readers.map((x) => x.id));
  const loans = (await all('/loans')).filter(
    (x) => bookIds.has(x.book?.id ?? x.bookId) || readerIds.has(x.reader?.id ?? x.readerId),
  );
  await purge('/loans', loans);
  await purge('/books', books);
  await purge('/readers', readers);
  await purge('/authors', (await all('/authors')).filter((x) => lecture.authors.includes(x.fullName)));
  await purge('/genres', (await all('/genres')).filter((x) => lecture.genres.includes(x.name)));
  await purge('/publishers', (await all('/publishers')).filter((x) => lecture.publishers.includes(x.name)));
}

async function sync(path, items, keyOf, payloadOf) {
  const existing = new Map((await all(path)).filter((row) => !row.deletedAt).map((row) => [keyOf(row), row.id]));
  const ids = new Map();
  let created = 0;
  for (const item of items) {
    const key = keyOf(item);
    if (existing.has(key)) {
      ids.set(item.id, existing.get(key));
      continue;
    }
    const row = await call('POST', path, payloadOf(item));
    ids.set(item.id, row.id);
    created++;
  }
  console.log(path.padEnd(11), 'добавлено:', created, 'из', items.length);
  return ids;
}

async function issueLoans(books, readers) {
  const existing = await all('/loans');
  const bookIds = new Set([...books.values()]);
  if (existing.some((x) => bookIds.has(x.book?.id ?? x.bookId))) {
    console.log('/loans      уже есть, пропускаю');
    return;
  }
  const readerIds = [...readers.values()];
  let next = 0;
  let created = 0;
  for (const book of data.books) {
    const taken = book.copiesTotal - book.copiesAvailable;
    for (let i = 0; i < taken; i++) {
      await call('POST', '/loans', {
        bookId: books.get(book.id),
        readerId: readerIds[next++ % readerIds.length],
        days: 14,
      });
      created++;
    }
  }
  console.log('/loans      выдано:', created);
}

async function main() {
  const login = await call('POST', '/auth/login', { username: USER, password: PASSWORD });
  token = login.accessToken;

  await removeLectureData();

  const genres = await sync('/genres', data.genres, (x) => x.name, (x) => ({
    name: x.name,
    description: x.description,
  }));
  const publishers = await sync('/publishers', data.publishers, (x) => x.name, (x) => ({
    name: x.name,
    city: x.city,
    foundedYear: x.foundedYear,
  }));
  const authors = await sync('/authors', data.authors, (x) => x.fullName, (x) => ({
    fullName: x.fullName,
    birthYear: x.birthYear,
    country: x.country,
  }));
  const readers = await sync('/readers', data.readers, (x) => x.email, (x) => ({
    fullName: x.fullName,
    email: x.email,
    phone: x.phone,
  }));
  const books = await sync('/books', data.books, (x) => x.isbn, (x) => ({
    title: x.title,
    isbn: x.isbn,
    year: x.year,
    pages: x.pages,
    publisherId: publishers.get(x.publisherId),
    authorIds: x.authorIds.map((id) => authors.get(id)),
    genreIds: x.genreIds.map((id) => genres.get(id)),
    copiesTotal: x.copiesTotal,
  }));
  await issueLoans(books, readers);
}

main().catch((error) => {
  console.error('Не удалось загрузить данные:', error.message);
  process.exit(1);
});
