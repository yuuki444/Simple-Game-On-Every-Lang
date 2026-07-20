package main

import (
	"fmt"
	"os"
	"time"
)

const (
	width  = 20
	height = 10
)

type Point struct {
	x, y int
}

func main() {
	snake := []Point{{x: 10, y: 5}, {x: 9, y: 5}, {x: 8, y: 5}}
	dir := Point{x: 1, y: 0}
	food := Point{x: 15, y: 5}
	score := 0
	inputChan := make(chan byte)
	go listenInput(inputChan)

	ticker := time.NewTicker(250 * time.Millisecond)
	defer ticker.Stop()

	//fixed!!!!!!!
	clearScreen()
	draw(snake, food, score)

	for {
		select {
		case b := <-inputChan:
			switch b {
			case 'w', 'W':
				if dir.y != 1 {
					dir = Point{x: 0, y: -1}
				}
			case 's', 'S':
				if dir.y != -1 {
					dir = Point{x: 0, y: 1}
				}
			case 'a', 'A':
				if dir.x != 1 {
					dir = Point{x: -1, y: 0}
				}
			case 'd', 'D':
				if dir.x != -1 {
					dir = Point{x: 1, y: 0}
				}
			case 'q', 'Q':
				fmt.Println("\nВыход из игры!")
				return
			}
		case <-ticker.C:
			newHead := Point{x: snake[0].x + dir.x, y: snake[0].y + dir.y}

			if newHead.x < 0 || newHead.x >= width || newHead.y < 0 || newHead.y >= height {
				fmt.Println("\nВрезались в стену! Игра окончена.")
				return
			}

			for _, part := range snake {
				if newHead.x == part.x && newHead.y == part.y {
					fmt.Println("\nЗмейка укусила себя! Игра окончена.")
					return
				}
			}

			snake = append([]Point{newHead}, snake...)

			if newHead.x == food.x && newHead.y == food.y {
				score += 10

				food = Point{
					x: (food.x + 7) % width,
					y: (food.y + 3) % height,
				}
			} else {
				snake = snake[:len(snake)-1]
			}
			clearScreen()
			draw(snake, food, score)
		}
	}
}

func listenInput(ch chan<- byte) {
	var b [1]byte
	for {
		os.Stdin.Read(b[:])
		ch <- b[0]
	}
}

func clearScreen() {
	fmt.Print("\033[H\033[2J")
}

func draw(snake []Point, food Point, score int) {
	fmt.Printf("Счет: %d | Управление: W/A/S/D + Enter (Q - выход)\n", score)

	for i := 0; i < width+2; i++ {
		fmt.Print("#")
	}
	fmt.Println()

	for y := 0; y < height; y++ {
		fmt.Print("#")
		for x := 0; x < width; x++ {
			if x == snake[0].x && y == snake[0].y {
				fmt.Print("O")
			} else if x == food.x && y == food.y {
				fmt.Print("*")
			} else {
				isBody := false
				for _, part := range snake[1:] {
					if part.x == x && part.y == y {
						fmt.Print("o")
						isBody = true
						break
					}
				}
				if !isBody {
					fmt.Print(" ")
				}
			}
		}
		fmt.Println("#")
	}

	for i := 0; i < width+2; i++ {
		fmt.Print("#")
	}
	fmt.Println()
}
