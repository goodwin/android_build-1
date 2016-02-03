# Copyright (C) 2015 DragonTC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Polly flags for use with Clang
POLLY := -mllvm -polly \
         -mllvm -polly-parallel -lgomp \
         -mllvm -polly-parallel-force \
	 -mllvm -polly-allow-nonaffine=1\
         -mllvm -polly-ast-detect-parallel \
         -mllvm -polly-no-early-exit \
         -mllvm -polly-vectorizer=stripmine \
         -mllvm -polly-opt-fusion=max \
         -mllvm -polly-opt-maximize-bands=yes

DISABLE_POLLY:= \
                $(LOCAL_DISABLE_POLLY)

# Make sure that the current module is not blacklisted. Polly is not
# used on host modules to reduce build time and unnecessary hassle.
# Optimizations on host do not affect ROM performance anyways.
ifneq (,$(filter true,$(LOCAL_CLANG)))
  ifeq (,$(filter true,$(LOCAL_IS_HOST_MODULE)))
    ifneq (1,$(words $(filter $(DISABLE_POLLY_TARGET),$(LOCAL_MODULE))))
      ifdef LOCAL_CFLAGS
        LOCAL_CFLAGS += -O2
      else
        LOCAL_CFLAGS := -O2
      endif
    else
      ifdef LOCAL_CFLAGS
        LOCAL_CFLAGS += -O2
      else
        LOCAL_CFLAGS := -O2
      endif
    endif
  endif
endif
