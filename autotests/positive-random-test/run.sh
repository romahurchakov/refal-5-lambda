#!/bin/bash

source ../../scripts/load-config.sh ../.. || exit 1
source ../../scripts/platform-specific.sh

LOOPS=10
if [ -n "$1" ]; then
  LOOPS="$1"
fi

main() {
  regression || return 1
  new_tests
  rm -f random$(platform_exe_suffix)
}

regression() {
  for r in saved-test-*.ref; do
    if run_test "$r" \
      && run_test "$r" -OP \
      && run_test "$r" -OR \
      && run_test "$r" -OPR \
      && run_test "$r" -Od \
      && run_test "$r" -OdP \
      && run_test "$r" -OdR \
      && run_test "$r" -OdPR
    then
      rm -f *.rasl *.cpp *.out* *.err*
    else
      return 1
    fi
  done
}

new_tests() {
  NOW=$(LC_ALL=C date | sed 's/[ :]/-/g')
  echo "start ($NOW, x$LOOPS) $(date)" >> time.txt
  ../../distrib/bin/srefc --slim random.ref
  if [ -e random$(platform_exe_suffix) ]; then
    rm -f random.rasl
  else
    return 1
  fi

  ./random$(platform_exe_suffix) $LOOPS _$NOW
  echo "gen ($NOW) $(date)" >> time.txt

  for r in test-*.ref; do
    if run_test "$r" \
      && run_test "$r" -OP \
      && run_test "$r" -OR \
      && run_test "$r" -OPR \
      && run_test "$r" -Od \
      && run_test "$r" -OdP \
      && run_test "$r" -OdR \
      && run_test "$r" -OdPR
    then
      rm -f ${r%%.ref}.*
    fi
  done

  echo "stop ($NOW) $(date)" >> time.txt
}

run_test() {
  FILE=${1%%.ref}
  FLAGS=$2

  echo "Passing $FILE ($FLAGS):"
  ../../bin/srefc-core --classic -C $FILE --prelude=prelude-for-test $FLAGS \
    2>$FILE.err$FLAGS >$FILE.out$FLAGS

  if [ ! -e $FILE.rasl ]; then
    return 1
  fi
  rm -f $FILE.rasl
}

main
