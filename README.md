# Exchange Office using Solidity

First, to check create a `.env` file in the root directory, and initialize `API_URL` and `PRIVATE_KEY`:

```dotenv
API_URL = "https://eth-sepolia.g.alchemy.com/v2/your-api-key"
PRIVATE_KEY = "your-metamask-private-key"
```

Then you need to compile them by

```angular2html
npx hardhat compile
npx hardhat run scripts/deploy.js --network sepolia
```