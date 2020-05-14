![Image screenshot main](screen1.jpg)

Image Listing

Scope: ​Retrieve, modify, store, cache and display a list of images.


Instructions:

- Lorem Picsum​ is a free online source for random images. This will be used to get images by calling the following endpoint https://picsum.photos/v2/list?page=1&limit=10​. Default page is 1 and the limit is established to 10 items per page. Read ​Lorem Picsum​ API’s description for more details.
- Loading process should be done progressively. Increment the page number and call the above endpoint until it returns an empty array.
- Images should be displayed in a UITableView/UICollectionView. No fancy styling required. Beside the actual image, the name of the author is required as well.
- On UITableView/UICollectionView list, each image should have a ​Fade ​filter applied. Code for adding a filter on UIImage is provided in this ​gist​.
- When tapping on an image, a new screen should be presented/pushed to display the ​original(without any filter)​ image in ​full size​.
- Images will be stored in a local database. Liberty to choose(Realm/CoreData etc). Database will act as a proxy between images retrieved from ​Lorem Picsum and listing/UI part.
- Caching​ should be done ​manually​, by using the database and local saving.
- Focus on ​optimization ​and​ code architecture​.
- Unit tests are not mandatory, but it would be nice to have.
- Liberty to choose any third party library.


Deadline: ​3 days
