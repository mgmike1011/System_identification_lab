#include <array>
#include <chrono>
#include <iostream>
#include <list>
#include <thread>
#include <queue>
#include <vector>
#include <atomic>

#define BUFFER_SIZE 5

int getPressureFromSensor()
{
    // funkcja "udająca" pobieranie danych z sensora z nieregularnym czasem pomiaru - nie ma potrzeby edycji.
    static const std::array<uint32_t, 13> dataGenerationIntervals_ms = {1, 200, 100, 100, 100, 100, 1, 1, 1, 1, 1, 1, 10000};
    static const std::array<int, 13> dataGenerationMeasurements = {101, 1002, 1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013};
    static size_t measurementIndex = 0;

    int value = dataGenerationMeasurements[measurementIndex];
    uint32_t dataGenerationTime = dataGenerationIntervals_ms[measurementIndex];
    std::this_thread::sleep_for(std::chrono::milliseconds(dataGenerationTime));
    measurementIndex++;

    std::cout << "* Sensor wygenerowal pomiar o wartosci: " << value << std::endl;
    return value;
}

void processPressureMeasurement(int value)
{
    // funkcja "udająca" przetwarzanie danych z sensora - nie ma potrzeby edycji.
    std::cout << "** Przetwarzanie odczytu z sensora o wartosci " << value << std::endl;
    std::this_thread::sleep_for(std::chrono::milliseconds(105));  // spanie emuluje dlugotrwale i skomplikowane obliczenia
}

// TODO - kod do uzupelnienia - utworzenie klasy bufora cyklicznego. Mozna skorzystac z ponizszych propozycji - jednak należy do nich dopisać definicje metod.

// Pierwsza propozycja na klasę bufora cyklicznego - wersja z wykorzystaniem prostych typów danych
class CircularBuffer
{
public:
    explicit CircularBuffer(size_t capacity): m_capacity(capacity+1){
        this->m_data = new int[m_capacity];
        this->m_tail = 0;
        this->m_head = 0;
    }

    int getValue(){
        int val = this->m_data[this->m_tail];
        this->m_tail = (this->m_tail + 1) % this->m_capacity;
        return val;
    }  // Odczytaj pomiar z bufora
    void addValue(int value){
        size_t newHead = (this->m_head + 1) % this->m_capacity;
        this->m_data[this->m_head] = value;
        this->m_head = newHead;
    }  // dodaj pomiar do bufora

    bool isEmpty() const{
        if(this->m_head == this->m_tail){
            return true;
        }else{
            return false;
        }
    }  // Sprawdz czy bufor jest pusty (czyli czy nie ma w nim zadnych danych do odczytania)
    bool isFull() const{
        if((this->m_head+1) % this->m_capacity == this->m_tail){
            return true;
        }else{
            return false;
        }
    }  // Sprawdz czy bufor jest pelny (czyli czy nie ma juz mozliwosci dodania nowych danych)

private:
    int* m_data;  // Data array, allocated in the constructor (and dealocated in destructor)
    size_t m_tail;  // Index w tablicy skąd będą odczytywane dane przy pobieraniu danych
    size_t m_head;  // Index w tablicy gdzie będą zapisywane nowe dane przy dodwaniu danych
    size_t m_capacity;
};

// UWAGA odnośnie sprawdzenia stanu pełnego i pustego bufora!
// ** Dla rozróżnienia pomiędzy stanem pełnym i pustym, rozmiar bufora może zostać sztucznie powiększony o 1 (capacity +1).
// ** Ostatnie miejsce nie będzie wykorzystywane do zapisu elementów, a jedynie do sprawdzania czy bufor jest pełny.
// ** Metoda isFull() powinna sprawdzać rozmiar z uzwzględnieniem dodatkowego miejsca, a metoda isEmpty()
// ** jedynie porównywać, czy head == tail.




/** Druga propozycja na klasę bufora cyklicznego - wersja z wykorzystaniem typów z przestrzeni nazw std

class CircularBuffer
{
public:
    CircularBuffer(const size_t& bufferLimit, const int& blankValue = 0); // Konstruktor powinien inicjowac wszystkie prywatne zmienne
    //Poczatkowy stan wewnętrznego bufora to maksymalne wypełnienie wartościami blankValue
    int front(); // Odczytaj pomiar z bufora (z jego końca - tail)
    void pop(); // Usuń element z końca bufora (tail) (wywołuj w kolejności 1. front() 2. pop())
    void emplace(int newElement); // Dodaj element do bufora (na jego początek - head)
    bool empty(); // Sprawdź, czy bufor jest pusty (sprawdz czy head == tail i czy !_is_full)
    bool full(); // Sprawdź, czy bufor jest pełny (zwroc _is_full)
private:
    const size_t m_bufferLimit; // Maksymalny rozmiar bufora cyklicznego
    std::list<int> m_data; // Wewnętrzny bufor do przechowywania elementów
    std::list<int>::iterator m_tail; // Iterator do miejsca odczytu danych
    std::list<int>::iterator m_head; // Iterator do miejsca dodawania danych
    const int m_blankValue; // Znak oznaczający wolne miejsce w buforze
    bool _is_full; // Flaga oznaczajaca, czy bufor jest pelny
};

// UWAGA odnośnie sprawdzenia stanu pełnego i pustego bufora!
// ** Ocena, czy bufor jest pelny odbywa się wewnątrz funkcji emplace
// ** wraz z odpowiednio UWARUNKOWANYM ustawieniem flagi _is_full, które następuje po dodaniu elementu.
// ** Ocena, czy bufor jest pusty odbywa się wewnątrz funkcji pop
// ** wraz z odpowiednim ustawieniem flagi _is_full, które następuje po usunięciu elementu.

*/

void runProducer(CircularBuffer& sensorMeasurementsBuffer, const std::atomic<bool>& program_running)
{
    while (program_running)
    {
        int sensorValue = getPressureFromSensor();  // pobieramy dane z sensora

        // TODO - kod do uzupelnienia
        // dodaj wartosc `sensorValue` do bufora `sensorMeasurementsBuffer`.
        // Jezeli w buforze nie ma już miejsca, wypisz komunikat:
        if(sensorMeasurementsBuffer.isFull()){
            std::cout << "*** Bufor pelny, odrzucony pomiar o wartości: " << sensorValue << std::endl;
        }else {
            sensorMeasurementsBuffer.addValue(sensorValue);
        }
    }
}

void runConsumer(CircularBuffer& sensorMeasurementsBuffer, const std::atomic<bool>& program_running)
{
    while (program_running)
    {
        // TODO - kod do uzupelnienia
        // jezeli w buforze 'sensorMeasurementsBuffer' znajduje się pomiar, odczytaj go i przetworz
//         int sensorValue = ...;
        // processPressureMeasurement(sesnsorValue)

        // jezeli bufor 'sensorMeasurementsBuffer' jest pusty, odczekaj 5ms
        if(sensorMeasurementsBuffer.isEmpty()){
         std::this_thread::sleep_for(std::chrono::milliseconds(5));
        }else {
            int sensorValue =sensorMeasurementsBuffer.getValue();
            processPressureMeasurement(sensorValue);
        }
    }
}


int main()
{
    CircularBuffer sensorMeasurementsBuffer(BUFFER_SIZE);  // bufor cykliczny do komunikacj między wątkami
    std::atomic<bool> program_running {true}; // Atomowy typ zagwarantuje aktualnosc zmiennej w kazdym z watkow
    std::thread producer(runProducer,std::ref(sensorMeasurementsBuffer),std::ref(program_running));
    std::thread consumer(runConsumer,std::ref(sensorMeasurementsBuffer),std::ref(program_running));

    // Na potrzeby zadania zakończymy działanie po określonym czasie;
    std::this_thread::sleep_for(std::chrono::milliseconds(1500));
    program_running = false;

    producer.join();
    consumer.join();
    return 0;
}
