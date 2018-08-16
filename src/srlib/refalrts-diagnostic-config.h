#ifndef RefalRTS_DIAGNOSTIC_CONFIG_H
#define RefalRTS_DIAGNOSTIC_CONFIG_H

#include <limits.h>
#include <stdio.h>


namespace refalrts {

struct DiagnosticConfig {
  unsigned long idents_limit;
  unsigned long memory_limit;
  unsigned long step_limit;
  unsigned long start_step_trace;
  bool print_statistics;
  bool dump_free_list;
  bool enable_debugger;
  char dump_file[FILENAME_MAX];

  static const unsigned long NO_LIMIT = ULONG_MAX;

  DiagnosticConfig()
    : idents_limit(NO_LIMIT)
    , memory_limit(NO_LIMIT)
    , step_limit(NO_LIMIT)
    , start_step_trace(NO_LIMIT)
    , print_statistics(false)
    , dump_free_list(false)
    , enable_debugger(false)
  {
    dump_file[0] = '\0';
  }
};

typedef void (*InitDiagnosticConfig)(DiagnosticConfig *config);

} // namespace refalrts


#endif // RefalRTS_DIAGNOSTIC_CONFIG_H
