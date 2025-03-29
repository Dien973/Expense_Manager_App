/// <reference path="../pb_data/types.d.ts" />
migrate((app) => {
  const collection = app.findCollectionByNameOrId("pbc_1736455494")

  // add field
  collection.fields.addAt(7, new Field({
    "hidden": false,
    "id": "file2548032275",
    "maxSelect": 1,
    "maxSize": 0,
    "mimeTypes": [],
    "name": "imageUrl",
    "presentable": false,
    "protected": false,
    "required": false,
    "system": false,
    "thumbs": [],
    "type": "file"
  }))

  return app.save(collection)
}, (app) => {
  const collection = app.findCollectionByNameOrId("pbc_1736455494")

  // remove field
  collection.fields.removeById("file2548032275")

  return app.save(collection)
})
