package main

import (
	"github.com/streadway/amqp"
	"io"
	"log"
	"os"
	"time"
)

func main() {
	log.SetOutput(os.Stdout)

	name := "./log/report.log"
	logFd, err := os.OpenFile(name + "_" + time.Now().Format("20160102"), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)
	if err != nil {
		log.Fatalf("error write file: %s", err.Error())
		return
	}
	defer logFd.Close()

	queue := "game_queue"

	url := "amqp://game:game@game-mq:5672/"
	conn, err := amqp.Dial(url)
	if err != nil {
		log.Fatalf("error connect: %s", err.Error())
		return
	}
	defer conn.Close()
	ch, err := conn.Channel()
	if err != nil {
		log.Fatalf("error create channel: %s", err.Error())
		return
	}
	defer ch.Close()

	msgs, err := ch.Consume(queue, "", true, false, false, false, nil)
	if err != nil {
		log.Fatalf("error receive: %s", err.Error())
		return
	}

	forever := make(chan bool)

	go func() {
		for d := range msgs {
			io.WriteString(logFd, string(d.Body)+"\n")
		}
	}()

	log.Printf(" [*] Waiting for messages. To exit press CTRL+C")
	<-forever
}
