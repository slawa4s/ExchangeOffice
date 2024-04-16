const {expect} = require('chai')

describe("Exchange Office contract", function () {
    it("Contract initialization test",
        async function () {
            const ExchangeOffice = await ethers.getContractFactory("CurrencyExchangeOffice");
            const exchange_office = await ExchangeOffice.deploy(100);

            expect(await exchange_office.getFakeBalance()).to.equal(BigInt(0));
        })

    it("Test refill",
        async function () {
            const ExchangeOffice = await ethers.getContractFactory("CurrencyExchangeOffice");
            const exchange_office = await ExchangeOffice.deploy(1000);

            const tokens = BigInt(228)

            await exchange_office.refill(tokens)
            expect(await exchange_office.getOfficeBalance()).to.equal(tokens);
        })

    it("Test purchase token",
        async function () {
            const ExchangeOffice = await ethers.getContractFactory("CurrencyExchangeOffice");
            const exchange_office = await ExchangeOffice.deploy(1);

            const tokens = BigInt(228)
            await exchange_office.refill(tokens)

            await exchange_office.purchaseFakeToken({ value: tokens });
            const balance_after = await exchange_office.getFakeBalance();

            expect(balance_after).to.equal(tokens);
        })

    it("Test office balance lower after user buy token",
        async function () {
            const ExchangeOffice = await ethers.getContractFactory("CurrencyExchangeOffice");
            const exchange_office = await ExchangeOffice.deploy(1);

            const tokens = BigInt(228)
            await exchange_office.refill(tokens)

            await exchange_office.purchaseFakeToken({ value: tokens });
            const office_balance_after = await exchange_office.getOfficeBalance();

            expect(office_balance_after).to.equal(BigInt(0));
        })

    it("Test throws if office balance is low",
        async function () {
            const ExchangeOffice = await ethers.getContractFactory("CurrencyExchangeOffice");
            const exchange_office = await ExchangeOffice.deploy(1);

            try {
                await exchange_office.purchaseFakeToken({value: BigInt(228)});
            } catch(error) {
                expect(error.message).to.contains("You can not buy so much tokens");
            }
        })

    it("Test user can buy and sell token",
        async function () {
            const ExchangeOffice = await ethers.getContractFactory("CurrencyExchangeOffice");
            const exchange_office = await ExchangeOffice.deploy(1);

            const tokens = BigInt(228)
            await exchange_office.refill(tokens)

            await exchange_office.purchaseFakeToken({ value: tokens });
            await exchange_office.sellFakeToken(tokens)
            const balance_after = await exchange_office.getFakeBalance();
            expect(balance_after).to.equal(BigInt(0));
        })

    it("Test user can not sell more then bought",
        async function () {
            const ExchangeOffice = await ethers.getContractFactory("CurrencyExchangeOffice");
            const exchange_office = await ExchangeOffice.deploy(1);

            const tokens = BigInt(228)
            await exchange_office.refill(tokens)

            await exchange_office.purchaseFakeToken({ value: tokens });
            try {
                await exchange_office.sellFakeToken(tokens + BigInt(1));
            } catch(error) {
                expect(error.message).to.contains("Low token balance");
            }
        })
    },
)