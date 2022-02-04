# PhotoCatalog

## Project Setup

1. Clone the project from this link `git@github.com:islamovic/PhotoCatalog.git`
3. Open `PhotoCatalog.xcodeproj` then Build and Run the project. 

## Project Architecture 

I'm Using VIP Clean Code, you can read more about it from <a href="https://hackernoon.com/introducing-clean-swift-architecture-vip-770a639ad7bf" target="_blank">Here</a>

## Project Component

### Scenes
- Is a Set of Scene, And Every Scene is a stand alone ViewController.
- Every Scene Has it's own `Interactor` Here is you can write all the business Logic.
- Every Scene Has it's own `Presenter` Here is you can write all the view Logic.

### Core
- It has only two main components:

#### KeychainService: It's a manager used for save and get data in and into KeyChain.
#### DataEncryption: It's a manager for encrypt and decrypt the data. 


### Utils
- Has some functionalities not related to any logic on the application but can be used more than omce. for example here we have 3 extensions for `String` converting strings to float values, and `UIImageView` for downloading images, and `UICollectionView` for handling the dequeuing and cell registeration.

### Networking
- Has all the network layer for the app to use.
- I just created a simple network layer based on use cases techniques that every web service should handle it own routers and use casee.


## Portrait Screenshots
<table>
  <tr>
     <td>Catalog List</td>
     <td>Create a new catalog Item</td>
     <td>Item Details</td>
  </tr>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/1983631/152577656-d95e50f6-3de1-4185-9dd6-c0bfe3151e82.png" width=270 height=480></td>
    <td><img src="https://user-images.githubusercontent.com/1983631/152577676-3c034a2a-b118-485e-be7c-be333fd405d8.png" width=270 height=480></td>
    <td><img src="https://user-images.githubusercontent.com/1983631/152577685-17b8478e-9077-4757-8fda-31f691ec5638.png" width=270 height=480></td>
  </tr>
 </table>
 
 ##
 
 ## Landscape Screenshots
<table>
  <tr>
     <td>Catalog List</td>
     <td>Create a new catalog Item</td>
     <td>Item Details</td>
  </tr>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/1983631/152577959-9ec92098-0d48-493f-bb96-88214b00b883.png" width=480 height=200></td>
    <td><img src="https://user-images.githubusercontent.com/1983631/152577979-f896eb5c-984c-4c33-8175-bcf709c7e61a.png" width=480 height=200></td>
    <td><img src="https://user-images.githubusercontent.com/1983631/152577991-7d94de3c-1f9d-4fb9-a02d-cc93bad374e9.png" width=480 height=200></td>
  </tr>
 </table>
 
 ##

## Test Cases

In Unit test case I diveded them to 4 folders.
- View Controller `To test the view controller connection with the interactors`
  - `CreateCatalogSceneViewControllerTests`
  - `CatalogListSceneViewControllerTests`

- Interactors `To test the interactor connection with presenataion view`
  - `CatalogListSceneInteractorTest`
  - `CreateCatalogSceneInteractorTests`
- Resources `To add some Mock data to use them in unit test cases`

- Netwok `To Test all the api's imnplmented inside the app`
  - `PhotosCatalogListWebServiceTests`
  - `CreatePhotoCatalogWebServiceTests`
  - `DownloadingImageWebServiceTests`

These covared about 65% of the code.
<img width="1295" alt="Screen Shot 2022-02-04 at 7 21 31 PM" src="https://user-images.githubusercontent.com/1983631/152579159-0bc95515-3d70-4923-886f-89c69ebbc79d.png">

