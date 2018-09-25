pragma solidity ^0.4.4;

contract Scmdapp {
    
    address ScmdappAdmin;

    // here we can look up the images by their 256hashes
    mapping ( bytes32 => notarizedImage) notarizedImages;
    
    // this is similar to a whitepages of all of the images, loading by their 256hash
    bytes32[] imagesByNotaryHash;

    // here we can lookup users by their eth address
    mapping ( address => User ) Users;

    // similar to the above bytes32[]. We have a list of all users
    address[] usersByAddress; 

    struct notarizedImage {
        string imageURL;
        uint timeStamp;
    }

    struct User {
        string handle;
        bytes32 city;
        bytes32 state;
        bytes32 country;
        bytes32[] myImages;
    }

    function registerNewUser(string handle, bytes32 city, bytes32 state, bytes32 country) public returns (bool success) {

        address thisNewAddress = msg.sender;

        if( bytes(Users[msg.sender].handle).length == 0 && bytes(handle).length != 0 ) {
            Users[thisNewAddress].handle = handle;
            Users[thisNewAddress].city = city;
            Users[thisNewAddress].state = state;
            Users[thisNewAddress].country = country;

            // Now we have all of the criteria required for a new user
            // so we push the new address to our master list of addresses
            usersByAddress.push(thisNewAddress);

            return true;
        } else {
            return false;
        }
    }

    function addImageToUser(string imageURL, bytes32 SHA256notaryHash) public returns (bool success) {

        address thisNewAddress = msg.sender;

        // Making sure they have created an account first
        if(bytes(Users[thisNewAddress].handle).length != 0) {
            
            // making sure that something was entered
            if(bytes(imageURL).length != 0) {
                
                // making sure the url doesn't already exist
                if(bytes(notarizedImages[SHA256notaryHash].imageURL).length == 0) {

                    // pushing the new image url to our list of all images
                    imagesByNotaryHash.push(SHA256notaryHash);
                }

                notarizedImages[SHA256notaryHash].imageURL = imageURL;
                notarizedImages[SHA256notaryHash].timeStamp = block.timestamp;

                // adding the image hash to the users list of images
                Users[thisNewAddress].myImages.push(SHA256notaryHash);

                return true;

            } else {
                
                // couldn't store the image
                return false;
            }
        } else {
            // User didn't have an account
            return false;
        }
    }

    function getUsers() public view returns ( address[] ) {
        return usersByAddress;
    }

    function getUser(address userAddress) public view returns (string, bytes32, bytes32, bytes32, bytes32[]) {
            
        return (
            Users[userAddress].handle, 
            Users[userAddress].city, 
            Users[userAddress].state, 
            Users[userAddress].country, 
            Users[userAddress].myImages
        );
    }

    function getAllImages() public view returns (bytes32[]) {
        return imagesByNotaryHash;
    }

    function getUserImages(address userAddress) public view returns (bytes32[]) {
        return Users[userAddress].myImages;
    }

    function getImage(bytes32 SHA256notaryHash) public view returns (string, uint) {
        return (notarizedImages[SHA256notaryHash].imageURL, notarizedImages[SHA256notaryHash].timeStamp);
    }


}

