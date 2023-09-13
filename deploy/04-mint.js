const {ethers, network} = require("hardhat")
const {developmentChains} = require("../helper-hardhat-config")

module.expports = async ({getNamedAccounts}) => {
    const {deployer} = await getNamedAccounts()

    // Basic NFT
    const basicNft = await ethers.getContract("BasicNft", deployer)
    const basicNftTx = await basicNft.mintNft()
    await basicNftTx.wait(1)
    console.log(`Basic NFT index 0 has tokenURI: ${await basicNft.tokenURI(0)}`)

    // Random IPFS NFT
    const randomIpfsNft = await ethers.getContract("RandomIpfsNft", deployer)
    const mintFee = await randomIpfsNft.getMintFee()
    await new Promise(async (resolve, reject) => {
        setTimeout(resolve, 40000)
        randomIpfsNft.once("NftMinted", async ()=>{
            resolve()
        })
        const randomIpfsNftMintTx = await randomIpfsNft.requestNft({value: mintFee.toString()})
        const randomIpfsNftMintTxReceipt = await randomIpfsNftMintTx.wait(1)
        if(developmentChains.includes(network.name)) {
            const requestId = randomIpfsNftMintTxReceipt.events[1].args.requestId.toString()
            const vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock", deployer)
            await vrfCoordinatorV2Mock.fulfillRandomWords(requestId, randomIpfsNft.address)
        }
    })
    console.log(`Random IPFS NFT index 0 has tokenURI: ${await randomIpfsNft.tokenURI(0)}`)

    // Dynamic NFT
}