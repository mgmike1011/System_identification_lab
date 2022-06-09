#include <iostream>
#include <thread>
#include <chrono>
#include <vector>
#include <mutex>
#include <atomic>

//############################################
// Zad 1
//void foo(){
//    std::cout<<std::this_thread::get_id()<<std::endl;
//}
//#############################################

int main() {
    std::cout<<"Podaj liczbe watkow"<<std::endl;
    //#############################################
    // Zad 1
    //    int ilosc =0;
    //    std::cin>>ilosc;
    //    std::cerr << "threads started" << std::endl;
    //    std::vector<std::thread> th_vec;
    //    for(int i=1;i<=ilosc;i++){
    //        th_vec.emplace_back(foo);
    //    }
    //    for(auto &th:th_vec){
    //        th.join();
    //    }
    //#############################################
    // Zad 3
    //    int liczba = 0;
    //    std::vector<std::thread> th_vec;
    //    for(int i=1;i<=1000;i++){
    //        th_vec.emplace_back([&liczba](){
    //            std::this_thread::sleep_for(std::chrono::milliseconds(10));
    //            liczba += 100;
    //        });
    //    }
    //    for(auto &th:th_vec){
    //           th.join();
    //       }
    //    std::cout<<liczba<<std::endl;
    //###########################################
    // Zad 4
    //        int liczba = 0;
    //        std::mutex mtx;
    //        std::vector<std::thread> th_vec;
    //        for(int i=1;i<=1000;i++){
    //            th_vec.emplace_back([&liczba,&mtx](){
    //                std::this_thread::sleep_for(std::chrono::milliseconds(10));
    //                std::lock_guard<std::mutex> lk_guard(mtx);
    //                liczba += 100;
    //            });
    //        }
    //        for(auto &th:th_vec){
    //               th.join();
    //           }
    //        std::cout<<liczba<<std::endl;
    //#########################################
    //    Zad 5
    std::atomic<int> liczba;
    liczba = 0;
    std::vector<std::thread> th_vec;
    for(int i=1;i<=1000;i++){
        th_vec.emplace_back([&liczba](){
            std::this_thread::sleep_for(std::chrono::milliseconds(10));
            liczba +=100;
        });
    }
    for(auto &th:th_vec){
        th.join();
    }
    std::cout<<liczba<<std::endl;

    std::cerr << "threads finished" << std::endl;

    return 0;
}
