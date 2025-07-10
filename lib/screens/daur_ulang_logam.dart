import 'package:flutter/material.dart';

class DaurUlangLogamPage extends StatefulWidget {
  const DaurUlangLogamPage({super.key});

  @override
  State<DaurUlangLogamPage> createState() => _DaurUlangLogamPageState();
}

class _DaurUlangLogamPageState extends State<DaurUlangLogamPage> {
  final List<Map<String, String>> metalTypes = [
    {
      'jenis': 'Aluminium',
      'contoh': 'Kaleng minuman, aluminium foil',
      'manfaat':
          'Daur ulang menjadi kaleng baru, komponen kendaraan, dan peralatan rumah tangga.',
    },
    {
      'jenis': 'Besi/Baja',
      'contoh': 'Kaleng makanan, paku, peralatan rumah tangga',
      'manfaat':
          'Didaur ulang menjadi baja baru untuk konstruksi dan industri.',
    },
    {
      'jenis': 'Tembaga',
      'contoh': 'Kabel listrik, pipa',
      'manfaat': 'Didaur ulang untuk produk elektronik dan instalasi listrik.',
    },
  ];

  final List<Map<String, dynamic>> _quiz = [
    {
      'question': 'Apa keuntungan mendaur ulang aluminium?',
      'options': [
        'Menghasilkan lebih banyak limbah',
        'Menghemat energi hingga 95%',
        'Membuat logam menjadi beracun',
        'Tidak ada manfaatnya',
      ],
      'answer': 1,
    },
    {
      'question': 'Apa saja contoh barang dari logam yang bisa didaur ulang?',
      'options': [
        'Botol plastik',
        'Kertas majalah',
        'Kaleng minuman dan paku',
        'Daun kering',
      ],
      'answer': 2,
    },
  ];

  int _currentQuestion = 0;
  int? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;

  void _submitAnswer() {
    if (_selectedAnswer == null) return;
    setState(() {
      _isAnswered = true;
      _isCorrect = _selectedAnswer == _quiz[_currentQuestion]['answer'];
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _quiz.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daur Ulang Logam'),
        backgroundColor: Colors.grey[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mengapa Daur Ulang Logam Penting?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Logam merupakan sumber daya tidak terbarukan. Daur ulang logam membantu menghemat energi, mengurangi emisi karbon, dan mengurangi ketergantungan pada penambangan baru.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Jenis Logam dan Contohnya',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            ...metalTypes.map(_buildMetalCard).toList(),
            const SizedBox(height: 24),
            const Text(
              'Fakta Menarik Tentang Daur Ulang Logam',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            _buildFact(
              'Mendaur ulang aluminium menghemat hingga 95% energi dibanding memproduksi dari bahan mentah.',
            ),
            _buildFact(
              'Besi tua dapat dilebur kembali dan digunakan untuk membangun gedung dan infrastruktur baru.',
            ),
            _buildFact(
              '1 ton baja daur ulang menghemat 1.100 kg bijih besi dan 630 kg batu bara.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Mini Kuis: Tes Pengetahuanmu!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            _buildQuizCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetalCard(Map<String, String> metal) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.precision_manufacturing, color: Colors.grey),
        title: Text(
          metal['jenis']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contoh: ${metal['contoh']}"),
            const SizedBox(height: 4),
            Text("Manfaat: ${metal['manfaat']}"),
          ],
        ),
      ),
    );
  }

  Widget _buildFact(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildQuizCard() {
    final current = _quiz[_currentQuestion];
    final isLast = _currentQuestion == _quiz.length - 1;

    return Card(
      margin: const EdgeInsets.only(top: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              current['question'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...(current['options'] as List<String>).asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final option = entry.value;
              return RadioListTile<int>(
                value: index,
                groupValue: _selectedAnswer,
                title: Text(option),
                onChanged:
                    _isAnswered
                        ? null
                        : (val) {
                          setState(() => _selectedAnswer = val);
                        },
              );
            }),
            const SizedBox(height: 12),
            if (!_isAnswered)
              ElevatedButton(
                onPressed: _selectedAnswer == null ? null : _submitAnswer,
                child: const Text('Kirim Jawaban'),
              )
            else ...[
              Text(
                _isCorrect
                    ? '✅ Jawaban benar!'
                    : '❌ Jawaban salah. Jawaban yang benar: ${current['options'][current['answer']]}',
                style: TextStyle(
                  color: _isCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (!isLast)
                ElevatedButton(
                  onPressed: _nextQuestion,
                  child: const Text('Soal Berikutnya'),
                )
              else
                const Text(
                  '🎉 Kuis selesai! Terima kasih telah belajar!',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
            ],
          ],
        ),
      ),
    );
  }
}