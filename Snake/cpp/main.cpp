#include <iostream>
#include <conio.h>
//console
#include <windows.h>
#include <vector>

using namespace std;


const int WIDTH = 20;
const int HEIGHT = 20;


struct Point {
    int x, y;
};

enum Direction { STOP = 0, LEFT, RIGHT, UP, DOWN };

bool gameOver;
Point head;
Point fruit;
vector<Point> tail;
Direction dir;
int score;

void Setup() {
    gameOver = false;
    dir = STOP;
    head.x = WIDTH / 2;
    head.y = HEIGHT / 2;

    fruit.x = rand() % WIDTH;
    fruit.y = rand() % HEIGHT;
    score = 0;
    tail.clear();
}

void Draw() {

    COORD coord = { 0, 0 };
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), coord);


    for (int i = 0; i < WIDTH + 2; i++) cout << "#";
    cout << endl;

    for (int i = 0; i < HEIGHT; i++) {
        for (int j = 0; j < WIDTH; j++) {

            if (j == 0) cout << "#";

            if (i == head.y && j == head.x) {
                cout << "O";
            } else if (i == fruit.y && j == fruit.x) {
                cout << "F";
            } else {
                bool isTail = false;
                for (const auto& t : tail) {
                    if (t.x == j && t.y == i) {
                        cout << "o";
                        isTail = true;
                        break;
                    }
                }
                if (!isTail) cout << " ";
            }

            if (j == WIDTH - 1) cout << "#";
        }
        cout << endl;
    }


    for (int i = 0; i < WIDTH + 2; i++) cout << "#";
    cout << endl;

    cout << "Score: " << score << endl;
}

void Input() {

    if (_kbhit()) {
        switch (_getch()) {
            case 'a': if (dir != RIGHT) dir = LEFT; break;
            case 'd': if (dir != LEFT) dir = RIGHT; break;
            case 'w': if (dir != DOWN) dir = UP; break;
            case 's': if (dir != UP) dir = DOWN; break;
            case 'x': gameOver = true; break;
        }
    }
}

void Logic() {
    if (dir == STOP) return;

    Point prev = head;
    for (size_t i = 0; i < tail.size(); i++) {
        Point temp = tail[i];
        tail[i] = prev;
        prev = temp;
    }

    switch (dir) {
        case LEFT:  head.x--; break;
        case RIGHT: head.x++; break;
        case UP:    head.y--; break;
        case DOWN:  head.y++; break;
        default: break;
    }

    if (head.x >= WIDTH || head.x < 0 || head.y >= HEIGHT || head.y < 0) {
        gameOver = true;
    }

    for (const auto& t : tail) {
        if (t.x == head.x && t.y == head.y) {
            gameOver = true;
        }
    }

    if (head.x == fruit.x && head.y == fruit.y) {
        score += 10;
        tail.push_back({0, 0});
        fruit.x = rand() % WIDTH;
        fruit.y = rand() % HEIGHT;
    }
}

int main() {
    void* handle = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_CURSOR_INFO structCursorInfo;
    GetConsoleCursorInfo(handle, &structCursorInfo);
    structCursorInfo.bVisible = FALSE;
    SetConsoleCursorInfo(handle, &structCursorInfo);

    Setup();
    while (!gameOver) {
        Draw();
        Input();
        Logic();
        Sleep(100);
    }

    cout << "Game Over!" << endl;
    return 0;
}
