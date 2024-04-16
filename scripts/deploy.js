async function main() {
    const ExchangeOffice = await ethers.getContractFactory("CurrencyExchangeOffice");
    const exchange_office = await ExchangeOffice.deploy(1);

    console.log("Contract deployed to address:", exchange_office.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });