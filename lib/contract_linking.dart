import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "http://0.0.0.0:7545";
  final String _wsUrl = "ws://0.0.0.0:7545/";
  final String _privateKey =
      "cf3f34d234a869d7d53d7cb30b109c953815758e17303b26cd3d073dfe34818e";
  final String _publicKey = "0xc2E0CDaB6Cb42e5446e523e570394D687Ea4f131";

  int? currentId;
  Web3Client? _client;
  bool isLoading = true;

  BigInt? totalSupply;

  String? _abiCode;
  EthereumAddress? _contractAddress;

  Credentials? _credentials;

  DeployedContract? _contract;

  ContractFunction? _mint;
  ContractFunction? _safeTransferFrom;

  ContractLinking() {
    initialSetup();
  }

  void initialSetup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  Future<void> getAbi() async {
    final abiStringFile = await rootBundle.loadString(
        "/Users/christian/block_chain_app/magazine_market_dapp/src/artifacts/ZineCollection.json");
    final jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = await _client?.credentialsFromPrivateKey(_privateKey);
  }

  Future<void> getDeployedContract() async {
    // Telling Web3dart where our contract is declared.
    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode!, "ZineCollection"),
      _contractAddress!,
    );

    // Extracting the functions, declared in contract.
    _mint = _contract?.function("mint");
    // _safeTransferFrom =

    _safeTransferFrom = _contract?.functions
        .where((element) => element.name == "safeTransferFrom")
        .first;

    var magazines = _contract?.function("magazineById");

    var mag = await _client?.call(
      contract: _contract!,
      function: magazines!,
      params: [
        EthereumAddress.fromHex("0x3AA0C988199b34248408d5E23C97f385df74ea5D"),
        BigInt.from(0)
      ],
    );

    print(mag);

    // for (var element in _contract!.functions) {
    //   print(element.name);
    // }
    notifyListeners();
  }

  Future updateCurrentId(int? newId) async {
    currentId = newId;
  }

  Future mint() async {
    int id = 0;
    await _client?.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _mint!,
        parameters: [
          EthereumAddress.fromHex(
            _publicKey,
          ),
        ],
      ),
    );

    var event = _contract?.event("Transfer");

    _client
        ?.events(FilterOptions.events(contract: _contract!, event: event!))
        .listen((event) async {
      await updateCurrentId(hexToDartInt(event.topics![3]));
    });
  }

  Future safeTransferFrom(
    EthereumAddress from,
    EthereumAddress to,
    BigInt tokenId,
  ) async {
    await _client?.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _safeTransferFrom!,
        parameters: [
          from,
          to,
          tokenId,
        ],
      ),
    );
  }
}
