package commands

import (
	"context"
	"flag"
	"fmt"
	"strings"

	"github.com/google/subcommands"
)

// printコマンドのための構造体
type printCmd struct {
	capitalize bool
}

// コマンド名
func (*printCmd) Name() string { return "print" }

// コマンド概要（ex. Print args to stdout.）
func (*printCmd) Synopsis() string { return "Print args to stdout." }

// コマンドの利用方法
func (*printCmd) Usage() string {
	return `print [-capitalize] <some text>:
  Print args to stdout.
`
}

// フラグの登録
func (p *printCmd) SetFlags(f *flag.FlagSet) {
	f.BoolVar(&p.capitalize, "capitalize", false, "capitalize output")
}

// printコマンド実行時の処理
func (p *printCmd) Execute(_ context.Context, f *flag.FlagSet, _ ...interface{}) subcommands.ExitStatus {
	for _, arg := range f.Args() {
		if p.capitalize {
			arg = strings.ToUpper(arg)
		}
		fmt.Printf("%s ", arg)
	}
	fmt.Println()
	return subcommands.ExitSuccess
}
