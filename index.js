const fs = require('fs');
const { ApolloServer, gql } = require("apollo-server");
const booksLambda = require('./books_lambda');
const randomLambda = require('./random_lambda');

const schema = fs.readFileSync('./schema.graphql').toString();
const typeDefs = gql(schema);

const resolvers = {
  Query: {
    books: booksLambda.handler,
  },
  Book: {
    rating: randomLambda.handler,
  }
};

const server = new ApolloServer({ typeDefs, resolvers });

server.listen().then(({ url }) => {
  console.log(`Server listening on ${url}`);
});
