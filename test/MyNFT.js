const MyNFT = artifacts.require("ZineCollection");

contract("ZineCollection", () => {
    let myNFT = null;
    var account1;
    var account2;

    before(async () => {
        myNFT = await MyNFT.deployed();
        let accounts = await web3.eth.getAccounts();
        account1 = accounts[0];
        account2 = accounts[1];
    });

    // it("Get Symbol", async () => {
    //     const symbol = await myNFT.symbol();
    //     assert(symbol === "ZC");
    // })

    // it("Mint a new NFT", async () => {
    //     await myNFT.mint(address1);
    //     const balance = await myNFT.balanceOf(address1);
    //     console.log(balance);
    //     assert(balance.length === 1);
    // })

    // it("Mint and transfer", async () => {
    //     await myNFT.mint(address1);
    //     await myNFT.safeTransferFrom(address1, address2, 1);
    //     const balance = await myNFT.balanceOf(address2);
    //     console.log(balance);
    //     assert(balance.length === 1);
    // })

    it("Add a new magazine", async () => {
        await myNFT.addNewMagazine(false, "摩耗", "助けてください", web3.utils.toWei("0.5", "ether"));
        await myNFT.mint(100);
        await myNFT.buyMagazine(0,account1, {
            from: account2,
            value: web3.utils.toWei("1", 'ether')
        });
    })
})

