import 'package:flutter/material.dart';

class DaurUlangKertasPage extends StatefulWidget {
  const DaurUlangKertasPage({super.key});

  @override
  State<DaurUlangKertasPage> createState() => _DaurUlangKertasPageState();
}

class _DaurUlangKertasPageState extends State<DaurUlangKertasPage> {
  final List<Map<String, String>> paperTypes = [
    {
      'jenis': 'Kertas HVS',
      'contoh': 'Kertas printer, fotokopi',
      'manfaat':
          'Dapat didaur ulang menjadi tisu, karton, dan kertas daur ulang.',
    },
    {
      'jenis': 'Karton/Kardus',
      'contoh': 'Kotak kemasan, kardus bekas',
      'manfaat': 'Didaur ulang menjadi karton baru atau bahan pelapis kemasan.',
    },
    {
      'jenis': 'Koran',
      'contoh': 'Surat kabar, majalah lama',
      'manfaat':
          'Dapat digunakan kembali untuk kertas cetak kasar, bahan isolasi, atau kerajinan.',
    },
  ];

  final List<Map<String, dynamic>> _quiz = [
    {
      'question': 'Apa manfaat utama daur ulang kertas?',
      'options': [
        'Meningkatkan limbah',
        'Mengurangi penebangan pohon',
        'Menambah emisi gas',
        'Menghasilkan plastik baru',
      ],
      'answer': 1,
    },
    {
      'question': 'Jenis kertas apa yang bisa didaur ulang menjadi tisu?',
      'options': ['Koran', 'Karton', 'Kertas HVS', 'Kertas laminasi'],
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
        title: const Text('Daur Ulang Kertas'),
        backgroundColor: Colors.orange[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mengapa Daur Ulang Kertas Penting?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kertas merupakan salah satu limbah terbesar dari rumah tangga dan perkantoran. Dengan mendaur ulang kertas, kita dapat mengurangi penebangan pohon, menghemat air, dan mengurangi volume sampah di tempat pembuangan akhir.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Jenis Kertas dan Contohnya',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            ...paperTypes.map(_buildPaperCard).toList(),
            const SizedBox(height: 24),
            const Text(
              'Fakta Menarik Tentang Daur Ulang Kertas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            _buildFact(
              'Daur ulang 1 ton kertas bisa menyelamatkan 17 pohon dan menghemat 26.000 liter air.',
            ),
            _buildFact(
              'Kertas dapat didaur ulang hingga 5–7 kali sebelum seratnya rusak.',
            ),
            _buildFact(
              'Setiap hari, ribuan ton kertas terbuang sia-sia karena tidak dipilah dengan benar.',
            ),
            _buildFact(
              'Mendaur ulang kertas mengurangi emisi gas rumah kaca dari pembakaran sampah.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Mini Kuis: Tes Pengetahuanmu!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            _buildQuizCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaperCard(Map<String, String> paper) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.description, color: Colors.orange),
        title: Text(
          paper['jenis']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contoh: ${paper['contoh']}"),
            const SizedBox(height: 4),
            Text("Manfaat: ${paper['manfaat']}"),
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
                onPressed:
                    _selectedAnswer == null ? null : () => _submitAnswer(),
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