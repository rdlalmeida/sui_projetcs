import { ConnectButton, useCurrentAccount, useSuiClientQuery } from '@mysten/dapp-kit';

function App() {
    return (
        <div className="App">
            <header className="App-header">
                <ConnectButton/>
            </header>
            <ConnectedAccount />
        </div>
    )
}

function ConnectedAccount() {
    const account = useCurrentAccount();

    if (!account) {
        return null;
    }

    return (
    <div>
        Connected to {account.address};
        <OwnedObjects address={account.address} />
    </div>
    )
}

function OwnedObjects({ address } : { address: string }) {
    const { data } = useSuiClientQuery('getOwnedObjects', {
        owner: address,
    });

    if (!data) {
        return null;
    }

    return(
        <ul>
            {data.data.map((object) => (
                <li key={object.data?.objectId}>
                    <a href={`https://example-explorer.com/object/${object.data?.objectId}`}>
                        {object.data?.objectId}
                    </a>
                </li>
            ))}
        </ul>
    )
}