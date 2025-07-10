import 'package:flutter/material.dart';

class DaurUlangPlastikPage extends StatefulWidget {
  const DaurUlangPlastikPage({super.key});

  @override
  State<DaurUlangPlastikPage> createState() => _DaurUlangPlastikPageState();
}

class _DaurUlangPlastikPageState extends State<DaurUlangPlastikPage> {
  final List<Map<String, String>> plasticTypes = [
    {
      'jenis': 'PET (1)',
      'contoh': 'Botol minuman, wadah makanan',
      'manfaat': 'Didaur ulang menjadi pakaian, serat tekstil, dan wadah baru.',
    },
    {
      'jenis': 'HDPE (2)',
      'contoh': 'Botol sampo, botol deterjen',
      'manfaat': 'Didaur ulang menjadi botol baru, pipa plastik, dan kotak.',
    },
    {
      'jenis': 'PVC (3)',
      'contoh': 'Pipa air, pembungkus makanan',
      'manfaat': 'Sulit didaur ulang, sering tidak diterima di fasilitas umum.',
    },
  ];

  final List<Map<String, dynamic>> _quiz = [
    {
      'question': 'Apa jenis plastik yang paling mudah didaur ulang?',
      'options': ['PVC', 'PET', 'LDPE', 'PS'],
      'answer': 1,
    },
    {
      'question': 'Apa manfaat utama daur ulang plastik?',
      'options': [
        'Meningkatkan limbah',
        'Mengurangi polusi dan penggunaan bahan baku baru',
        'Mempercepat pembakaran',
        'Menghasilkan limbah beracun',
      ],
      'answer': 1,
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
        title: const Text('Daur Ulang Plastik'),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mengapa Daur Ulang Plastik Penting?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Daur ulang plastik membantu mengurangi pencemaran lingkungan, menyelamatkan hewan laut, dan mengurangi kebutuhan bahan baku minyak bumi. Plastik bisa terurai hingga ratusan tahun jika tidak dikelola dengan baik.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Jenis Plastik dan Contohnya',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            ...plasticTypes.map(_buildPlasticCard).toList(),
            const SizedBox(height: 24),
            const Text(
              'Fakta Menarik Tentang Daur Ulang Plastik',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            _buildFact(
              'Botol plastik membutuhkan waktu hingga 450 tahun untuk terurai.',
            ),
            _buildFact(
              'Kurang dari 10% plastik global benar-benar didaur ulang.',
            ),
            _buildFact('Daur ulang plastik dapat menghemat energi hingga 80%.'),
            _buildFact(
              'Plastik daur ulang digunakan untuk membuat karpet, pakaian, hingga bangku taman.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Mini Kuis: Tes Pengetahuanmu!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            _buildQuizCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlasticCard(Map<String, String> plastic) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.recycling, color: Colors.blue),
        title: Text(
          plastic['jenis']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contoh: ${plastic['contoh']}"),
            const SizedBox(height: 4),
            Text("Manfaat: ${plastic['manfaat']}"),
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
          const Icon(Icons.lightbulb, color: Colors.green),
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
                        : (val) => setState(() => _selectedAnswer = val),
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