---
code: false
type: page
title: Introduction
description: KuzzleRequest object description
order: 0
---

## KuzzleRequest

`KuzzleRequest` is a **serializable** class representing a raw Kuzzle request.


## Properties

| Property | Type | Description |
|--- |--- |--- |
| `action` | <pre>String</pre> | Executed Kuzzle API controller's action `
| `body` | <pre>Map<String, dynamic> body</pre> |
| `collection` | <pre>String</pre> | Impacted collection |
| `controller` | <pre>String</pre> | Executed Kuzzle API controller |
| `index` | <pre>String</pre> | Impacted index |
| `jwt` | <pre>String</pre> | Authentication token |
| `lang` | <pre>String</pre> | ES lang |
| `requestId` | <pre>String</pre> | Request unique identifier |
| `waitForRefresh` | <pre>bool</pre> | If set to `true`, Kuzzle will wait for the persistence layer to finish indexing |
| `volatile` | <pre>Map<String, dynamic></pre> | Volatile data |
| `from`     | <pre>int</pre><br/>(`0`)    | Offset of the first document to fetch |
| `size`     | <pre>int</pre><br/>(`10`)   | Maximum number of documents to retrieve per page |
| `scroll`   | <pre>String</pre><br/>(`""`)    | When set, gets a forward-only cursor having its ttl set to the given value (ie `1s`; cf [elasticsearch time limits](https://www.elastic.co/guide/en/elasticsearch/reference/7.3/common-options.html#time-units)) |
| `scrollId` | <pre>String</pre> | The scrollId if using scroll option |
| `sort` | <pre>List<dynamic></pre> | Contains a list of fields, used to [sort search results](https://www.elastic.co/guide/en/elasticsearch/reference/7.3/search-request-sort.html), in order of importance. |

## Overrided operators

The `[]` and `[]=` are overrided so you can dynamically add any args you want to this class and it will be taken in consideration in the request sent to Kuzzle.
