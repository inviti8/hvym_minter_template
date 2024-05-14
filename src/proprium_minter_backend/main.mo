// Import the necessary packages
import Prim "mo:prim";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Random "mo:base/Random";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import Time "mo:base/Time";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import Nat8 "mo:base/Nat8";
import Nat16 "mo:base/Nat16";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import List "mo:base/List";
import AssocList "mo:base/AssocList";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Bool "mo:base/Bool";
import Principal "mo:base/Principal";
import Error "mo:base/Error";
import SHA256 "./SHA256";
import Hex "./Hex";
import Types "./Types";
import Uploader "./Uploader";
import Map "./Map";
import { thash } "./Map";
import { nhash } "./Map";


shared({ caller = custodian }) actor class() {

  stable var logo : Types.LogoResult = {
    logo_type = "fdfgdfgdfgd";
    data = "sddsadas";
  };
  stable var nft : Types.HVYM_721_NFT = {
    logo = logo;
    name = "Alice";
    symbol = "HVYM";
    maxLimit = 42;
  };
  stable var transactionId: Types.TransactionId = 0;
  stable var released: Types.Released = false;
  stable var nfts = List.nil<Types.Nft>();
  stable var custodians = List.nil<Principal>();
  stable var name : Text = nft.name;
  stable var symbol : Text = nft.symbol;
  stable var maxLimit : Nat16 = nft.maxLimit;

  stable var Life  = 10000000;
  stable var Power = 10000;

  stable var creator : Text = "9736E490E70CE33B10B9281C167266A6434774503057D47DC69341016BA8351D";

  // https://forum.dfinity.org/t/is-there-any-address-0-equivalent-at-dfinity-motoko/5445/3
  let null_address : Principal = Principal.fromText("aaaaa-aa");
  let anonymous = Principal.fromText("2vxsx-fae");
  type FileId = Uploader.FileId;
  type FileInfo = Uploader.FileInfo;
  type FileData = Uploader.FileData;
  type ChunkId = Uploader.ChunkId;
  type State = Uploader.State;

  var state = Uploader.empty();
  let limit = 20_000_000_000_000;

  stable var Ammo: Types.ValueProperty = {
    default = 0;
    min = 0;
    max = 100;
    amount = 1;
  };
  stable var AmmoProps = Map.new<Nat, Types.Ammo>();

  public query({ caller }) func greet() : async Text {
    return "Hello, " # Principal.toText(caller) # "!";
  };

  public query({ caller }) func greet256(user: Principal) : async Text {
    return "Hello, " # Principal.toText(caller) # "!";
    //return Hex.encode(SHA256.sha256(Blob.toArray(Text.encodeUtf8(Principal.toText(user)))), #upper);
  };

  public query func auth_greet(user: Principal, name : Text) : async Text {
    // If an identity with admin rights calls the method, display this greeting:
    if (List.some(custodians, func (custodian : Principal) : Bool { custodian == user }))  {
      return "Hello, " # name # ". You have a role with administrative privileges."
    // If an identity with the authorized user rights calls the method, display this greeting:
    } else {
      return "Greetings, " # name # ". Nice to meet you!";
    }
  };

  public func increment_Life(user: Principal) : async Nat {
    Life += 1;
    return Life;
  };

  public func decrement_Power(user: Principal) : async Nat {
    Power -= 1;
    return Power;
  };

  public func increment_Ammo(user: Principal, token_id: Types.TokenId) : async ?Nat {
    let id = Nat64.toNat(token_id);
    let value = Map.get<Nat, Nat>(AmmoProps, nhash, id);
    let item = List.filter(nfts, func(token: Types.Nft) : Bool { token.owner == user and Nat64.toNat(token.id) == id });

    switch (value) {
      case (null) {
          return null;
        };
      case (?value) {
        if(value > Ammo.max or value < Ammo.min ){
          return null;
        }else{
          switch (item) {
            case (null) {
              return null;
            };
            case (?token) {
              return Map.replace<Nat, Nat>(AmmoProps, nhash, id, value + Ammo.amount);
            };
          };
        }
      };
    };
  };

  public func decrement_Ammo(user: Principal, token_id: Types.TokenId) : async ?Nat {
    let id = Nat64.toNat(token_id);
    let value = Map.get<Nat, Nat>(AmmoProps, nhash, id);
    let item = List.filter(nfts, func(token: Types.Nft) : Bool { token.owner == user and Nat64.toNat(token.id) == id});

    switch (value) {
      case (null) {
          return null;
        };
      case (?value) {
        if(value > Ammo.max or value < Ammo.min ){
          return null;
        }else{
          switch (item) {
            case (null) {
              return null;
            };
            case (?token) {
              return Map.replace<Nat, Nat>(AmmoProps, nhash, id, value - Ammo.amount);
            };
          };
        }
      };
    };
  };

  public query func get_Ammo(user: Principal, token_id: Types.TokenId) : async ?Nat {
    let item = List.filter(nfts, func(token: Types.Nft) : Bool { token.owner == user and token.id == token_id});

    switch (item) {
      case (null) {
        return null;
      };
      case (?token) {
        return Map.get<Nat, Nat>(AmmoProps, nhash, Nat64.toNat(token_id));
      };
    };
  };

  public query func test_int(user: Principal, num : Nat16) : async Nat16 {

    return num + 1;
  };

  public query func balanceOf(user: Principal) : async Nat64 {
    return Nat64.fromNat(
      List.size(
        List.filter(nfts, func(token: Types.Nft) : Bool { token.owner == user })
      )
    );
  };

  public query func ownerOf(token_id: Types.TokenId) : async Types.OwnerResult {
    let item = List.find(nfts, func(token: Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case (null) {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        return #Ok(token.owner);
      };
    };
  };

  public shared({ caller }) func safeTransferFrom(from: Principal, to: Principal, token_id: Types.TokenId) : async Types.TxReceipt {  
    if (to == null_address) {
      return #Err(#ZeroAddress);
    } else {
      return transferFrom(from, to, token_id, caller);
    };
  };

  public shared({ caller }) func nftTransferFrom(from: Principal, to: Principal, token_id: Types.TokenId) : async Types.TxReceipt {
    return transferFrom(from, to, token_id, caller);
  };

  func transferFrom(from: Principal, to: Principal, token_id: Types.TokenId, caller: Principal) : Types.TxReceipt {
    let item = List.find(nfts, func(token: Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case null {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        if (
          caller != token.owner and
          not List.some(custodians, func (custodian : Principal) : Bool { custodian == caller })
        ) {
          return #Err(#Unauthorized);
        } else if (Principal.notEqual(from, token.owner)) {
          return #Err(#Other);
        } else {
          nfts := List.map(nfts, func (item : Types.Nft) : Types.Nft {
            if (item.id == token.id) {
              let update : Types.Nft = {
                owner = to;
                id = item.id;
                imageId = item.imageId;
                metadata = token.metadata;
              };
              return update;
            } else {
              return item;
            };
          });
          transactionId += 1;
          return #Ok(transactionId);   
        };
      };
    };
  };

  public query func supportedInterfaces() : async [Types.InterfaceId] {
    return [#TransferNotification, #Burn, #Mint];
  };

  public query func nftLogo() : async Types.LogoResult {
    return logo;
  };

  public query func nftName() : async Text {
    return name;
  };

  public query func nftSymbol() : async Text {
    return symbol;
  };

  public query func totalSupply() : async Nat64 {
    return Nat64.fromNat(
      List.size(nfts)
    );
  };

  public query func isReleased() : async Bool {
    return released;
  };

  public query func isCreator(user: Principal) : async Bool {
    return true;
  };

  public query func getTokenMetadataForUser(user: Principal, token_id: Types.TokenId) : async Types.ExtendedMetadataResult {
    if (Principal.equal(user, anonymous)){return #Err(#Unauthorized);};
    let item = List.find(nfts, func(token: Types.Nft) : Bool { token.owner == user and token.id == token_id });
    switch (item) {
      case null {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        return #Ok({
          metadata_desc = token.metadata;
          token_id = token.id;
          image_id = token.imageId;
        });
      }
    };
  };

  public query func getImageId(token_id: Types.TokenId) : async Types.ImageIdResult {
    let item = List.find(nfts, func(token: Types.Nft) : Bool { token.id == token_id });
    switch (item) {
      case null {
        return #Err(#InvalidTokenId);
      };
      case (?token) {
        return #Ok(token.imageId);
      }
    };
  };

  public query func getMaxLimit() : async Nat16 {
    return maxLimit;
  };

  public shared func release(user: Principal) : async Types.Released {
    if (Principal.equal(user, anonymous)){return false;};
    let hex = Hex.encode(SHA256.sha256(Blob.toArray(Text.encodeUtf8(Principal.toText(user)))), #upper);

    if (hex != creator) {
      return false;
    }else if(hex == creator and released == false){
      custodians := List.push(user, custodians);
    };
    
    released := true;

    return released;
  };

  public query func getAllTokensForUser(user: Principal) : async [Types.Nft] {
    let items = List.filter(nfts, func(token: Types.Nft) : Bool { token.owner == user });
    return List.toArray(items);
  };

  public query func getTokenIdsForUser(user: Principal) : async [Types.TokenId] {
    let items = List.filter(nfts, func(token: Types.Nft) : Bool { token.owner == user });
    let tokenIds = List.map(items, func (item : Types.Nft) : Types.TokenId { item.id });
    return List.toArray(tokenIds);
  };

  public query func getAllTokenMetaDataForUser(user: Principal) : async [Types.MetadataDesc] {
    let items = List.filter(nfts, func(token: Types.Nft) : Bool { token.owner == user });
    let metaDatas = List.map(items, func (item : Types.Nft) : Types.MetadataDesc { item.metadata });
    return List.toArray(metaDatas);
  };

  public shared({ caller }) func mint(to: Principal, imgId: Uploader.FileId, metadata: Types.MetadataDesc) : async Types.MintReceipt {
    if (Principal.equal(caller, anonymous)){return #Err(#Unauthorized);};
    // if (not List.some(custodians, func (custodian : Principal) : Bool { custodian == caller }) and released) {
    //   return #Err(#Unauthorized);
    // };

    let newId = Nat64.fromNat(List.size(nfts));
    let nft : Types.Nft = {
      owner = to;
      id = newId;
      imageId = imgId;
      metadata = metadata;
    };

    nfts := List.push(nft, nfts);
    Map.set(AmmoProps, nhash, transactionId, 0);

    transactionId += 1;

    return #Ok({
      token_id = newId;
      id = transactionId;
    });
  };

  public func getSize(): async Nat {
    Debug.print("canister balance: " # Nat.toText(Cycles.balance()));
    Prim.rts_memory_size();
  };
  // consume 1 byte of entrypy
  func getrByte(f : Random.Finite) : ? Nat8 {
    do ? {
      f.byte()!
    };
  };
  // append 2 bytes of entropy to the name
  // https://sdk.dfinity.org/docs/base-libraries/random
  public func generateRandom(name: Text): async Text {
    var n : Text = name;
    let entropy = await Random.blob(); // get initial entropy
    var f = Random.Finite(entropy);
    let count : Nat = 2;
    var i = 1;
    label l loop {
      if (i >= count) break l;
      let b = getrByte(f);
      switch (b) {
        case (?b) { n := n # Nat8.toText(b); i += 1 };
        case null { // not enough entropy
          Debug.print("need more entropy...");
          let entropy = await Random.blob(); // get more entropy
          f := Random.Finite(entropy);
        };
      };
      
    };
    
    n
  };

  func createFileInfo(fileId: Text, fi: FileInfo) : ?FileId {
          switch (state.files.get(fileId)) {
              case (?_) { /* error -- ID already taken. */ null }; 
              case null { /* ok, not taken yet. */
                  Debug.print("id is..." # debug_show(fileId));   
                  state.files.put(fileId,
                                      {
                                          fileId = fileId;
                                          cid = custodian;
                                          name = fi.name;
                                          createdAt = fi.createdAt;
                                          uploadedAt = Time.now();
                                          chunkCount = fi.chunkCount;
                                          size = fi.size ;
                                          extension = fi.extension;
                                      }
                  );
                  ?fileId
              };
          }
  };

  public shared({ caller }) func putFile(fi: FileInfo) : async ?FileId {
    if (Principal.equal(caller, anonymous)){return null;};
    do ? {
      // append 2 bytes of entropy to the name
      let fileId = await generateRandom(fi.name);
      createFileInfo(fileId, fi)!;
    }
  };

  func chunkId(fileId : FileId, chunkNum : Nat) : ChunkId {
      fileId # (Nat.toText(chunkNum))
  };
  // add chunks 
  // the structure for storing blob chunks is to unse name + chunk num eg: 123a1, 123a2 etc
  public shared({ caller }) func putChunks(fileId : FileId, chunkNum : Nat, chunkData : Blob) : async ?() {
    if (Principal.equal(caller, anonymous)){return null;};
    do ? {
      Debug.print("generated chunk id is " # debug_show(chunkId(fileId, chunkNum)) # "from"  #   debug_show(fileId) # "and " # debug_show(chunkNum)  #"  and chunk size..." # debug_show(Blob.toArray(chunkData).size()) );
      state.chunks.put(chunkId(fileId, chunkNum), chunkData);
    }
  };

  func getFileInfoData(fileId : FileId) : ?FileData {
    do ? {
      let v = state.files.get(fileId)!;
      {
        fileId = v.fileId;
        cid = v.cid;
        name = v.name;
        size = v.size;
        chunkCount = v.chunkCount;
        extension = v.extension;
        createdAt = v.createdAt;
        uploadedAt = v.uploadedAt;
      }
    }
  };

  public query({ caller }) func getFileInfo(fileId : FileId) : async ?FileData {
    if (Principal.equal(caller, anonymous)){return null;};
    do ? {
      getFileInfoData(fileId)!
    }
  };

  public query func getChunks(fileId : FileId, chunkNum: Nat) : async ?Blob {
      state.chunks.get(chunkId(fileId, chunkNum))
  };

  public query func getInfo() : async [FileData] {
    let b = Buffer.Buffer<FileData>(0);
    let _ = do ? {
      for ((f, _) in state.files.entries()) {
        b.add(getFileInfoData(f)!)
      };
    };
    Buffer.toArray(b)
  };

  public func wallet_receive() : async { accepted: Nat64 } {
    let available = Cycles.available();
    let accepted = Cycles.accept(Nat.min(available, limit));
    { accepted = Nat64.fromNat(accepted) };
  };

  public func wallet_balance() : async Nat {
    return Cycles.balance();
  };

};
