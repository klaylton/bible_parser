require_relative '../../spec_helper'

describe BibleParser::Chapter do
  let(:path)   { fixture_path('web.usfx.truncated.xml') }
  let(:file)   { File.open(path) }
  let(:parser) { BibleParser::Parsers::USFX::Parser.new(file) }

  subject { described_class.new(book_id: 'EXO', book_num: 2, book_title: 'Exodus', num: 1, parser: parser) }

  describe '#book_id' do
    it 'returns the book id' do
      expect(subject.book_id).to eq('EXO')
    end
  end

  describe '#book' do
    it 'returns a book instance' do
      expect(subject.book).to eq(
        BibleParser::Book.new(
          id: 'EXO',
          num: 2,
          title: 'Exodus',
          parser: parser
        )
      )
    end
  end

  describe '#each_verse' do
    context 'without a block' do
      let(:verses) { subject.each_verse }
      let(:first)  { verses.first }
      let(:last)   { verses.to_a.last }

      it 'returns an enumerable of verses for this chapter' do
        expect(verses).to be_an(Enumerable)
        expect(first).to be_a(BibleParser::Verse)
        expect(first.num).to eq(1)
        expect(last.num).to eq(4)
      end
    end

    context 'with a block' do
      let(:verses) { [] }

      before do
        subject.each_verse do |verse|
          verses << verse
        end
      end

      it 'returns an enumerable of verses for this chapter' do
        expect(verses.size).to eq(4)
        expect(verses.first).to be_a(BibleParser::Verse)
        expect(verses.first.num).to eq(1)
        expect(verses.last.num).to eq(4)
      end
    end
  end

  describe '#verses' do
    let(:verses) { subject.verses }

    it 'returns an array of all verses' do
      expect(verses.size).to eq(4)
      expect(verses.first).to be_a(BibleParser::Verse)
      expect(verses.first.num).to eq(1)
      expect(verses.last.num).to eq(4)
    end
  end
end
