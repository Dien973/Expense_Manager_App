/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_2495744586")

  // update collection data
  unmarshal({
    "name": "categories"
  }, collection)

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_2495744586")

  // update collection data
  unmarshal({
    "name": "catrgory"
  }, collection)

  return app.save(collection)
})
