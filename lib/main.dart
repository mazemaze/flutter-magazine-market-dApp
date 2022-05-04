import 'package:flutter/material.dart';
import 'package:magazine_market_dapp/contract_linking.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ContractLinking(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final contractLink = Provider.of<ContractLinking>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.book, color: Colors.blue),
            Text(
              'ZineMarket',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              _buildWalletInfo(),
              Expanded(
                child: ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (ctx, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Article(
                      article: articles[i],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const ArticleRegistrationPage(),
          ),
        ),
        child: const Icon(Icons.add, color: Colors.blue),
      ),
    );
  }

  Widget _buildWalletInfo() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Unnamed",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Address: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "Amount: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 32,
          ),
        ],
      ),
    );
  }
}

var articles = <ArticleModel>[
  ArticleModel(
    id: 0,
    title: "部屋の片付け方",
    content: "部屋を掃除するために必要な１０個の要素を紹介しましう。以下略",
  ),
  ArticleModel(
    id: 0,
    title: "世界征服を行う方法",
    content: "部屋を掃除するために必要な１０個の要素を紹介しましう。以下略",
  ),
  ArticleModel(
    id: 0,
    title: "異世界転生したい方へ",
    content: "部屋を掃除するために必要な１０個の要素を紹介しましう。以下略",
  ),
  ArticleModel(
    id: 0,
    title: "名前ってなんだ",
    content: "部屋を掃除するために必要な１０個の要素を紹介しましう。以下略",
  ),
];

class ArticleRegistrationPage extends StatelessWidget {
  const ArticleRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _title = TextEditingController();
    TextEditingController _content = TextEditingController();
    final contractLink = Provider.of<ContractLinking>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.blue,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: _title,
                    decoration: const InputDecoration(
                      hintText: "タイトル",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 600,
                  child: TextField(
                    controller: _content,
                    maxLines: 100,
                    decoration: const InputDecoration(
                      hintText: "内容",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await contractLink.mint();
                      var id = contractLink.currentId;
                      articles.add(
                        ArticleModel(
                          id: id!,
                          title: _title.text,
                          content: _content.text,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "保存",
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Article extends StatelessWidget {
  const Article({Key? key, this.article}) : super(key: key);
  final ArticleModel? article;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black26,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article!.title!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(),
          Text(
            article!.content!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text("購入する"),
                  onPressed: () => print(""),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  child: const Icon(Icons.favorite_outline),
                  onPressed: () => print(""),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ArticleModel {
  int id;
  String? title;
  String? content;
  DateTime? createdAt;
  DateTime? updatedAt;
  ArticleModel({
    required this.id,
    this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
  });
}
