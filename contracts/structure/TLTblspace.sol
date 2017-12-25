pragma solidity ^0.4.15;

import "./Util.sol";
import "./TLType.sol";


library TLTblspace {

    using TiesLibString for string;

    function createTable(TLType.Tablespace storage ts, string tName) public returns (bytes32) {
        require(!tName.isEmpty());
        var tKey = tName.hash();
        require(!hasTable(ts, tKey) && ts.rs.canCreateTable(ts.name, tName, msg.sender));
        ts.tm[tKey] = TLType.Table({
            name: tName, ts: ts, tmi: ts.tmis.length,
            fmis: new bytes32[](0), trmis: new bytes32[](0)
        });
        ts.tmis.push(tKey);
        return tKey;
    }

    function deleteTable(TLType.Tablespace storage ts, bytes32 tKey) public {
        var t = ts.tm[tKey];
        require(!t.name.isEmpty() && ts.rs.canDeleteTable(ts.name, t.name, msg.sender));
        assert(ts.tmis.length > 0); //If we are here then there must be table in array

        var idx = t.tmi;
        if (ts.tmis.length > 1 && idx != ts.tmis.length-1) {
            ts.tmis[idx] = ts.tmis[ts.tmis.length-1];
            ts.tm[ts.tmis[idx]].tmi = idx;
        }

        delete ts.tmis[ts.tmis.length-1];
        ts.tmis.length--;

        delete ts.tm[tKey];
    }

    function hasTable(TLType.Tablespace storage ts, bytes32 tKey) public constant returns (bool) {
        return !ts.tm[tKey].name.isEmpty();
    }

    function getTablesKeys(TLType.Tablespace storage ts) internal constant returns (bytes32[]) {
        require(!ts.name.isEmpty());
        return ts.tmis;
    }

    function getTablespaceName(TLType.Tablespace storage ts) internal constant returns (string) {
        require(!ts.name.isEmpty());
        return ts.name;
    }


}