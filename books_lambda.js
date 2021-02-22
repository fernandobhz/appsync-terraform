const books = require('./books')

exports.handler = async (events) => {
  console.log({ events });

  console.log({ books });

  return books;
};
