package tokipona

import lib "../lib"
import fmt "core:fmt"
import os "core:os"

import lua "vendor:lua/5.1"


main :: proc () {


    lu : lua.State = lua.newstate()

    ret : lua.Status = lua.L_loadfile(lu, "./t/test.lua")
    if !(ret == lua.Status.OK) {
        lua.L_error(ret, "Lua_loadfile Failed.")
        exit("Error")
    }

    fmt.println("is C, calling lua")

    re = lua.pcall(lu, 0, 0, 0)
    if !(ret == lua.Status.OK) {
        lua.L_error(ret, "lua pcall() failed")
        exit("error")
    }

    lua.close(lua)

    return
}

read_entire_file_from_path :: proc(file_path_name: string) -> (string, bool) {

  data_text_digest, ok := os.read_entire_file(
    file_path_name,
    context.allocator,
  )
  if !ok {
    // could not read file
    fmt.println("cannot read file")
    return "", false
  }

  return string(data_text_digest), ok
}

main_test_input :: proc() {

  FILE_TEST_NAME :: "./t/toki_pona_text_nasa.tkp"
  // fmt.println("Hello World")

  scand: lib.Scanner

  text_data, ok := read_entire_file_from_path(FILE_TEST_NAME)
  defer delete(text_data, context.allocator)

  if !ok {
    fmt.println("erro on read file")
    os.exit(1)
  }

  // fmt.println(text_data)


  lib.init(&scand, text_data, "test")

  fmt.println(scand.line)

  token_s: rune


  READ: for {

    // fmt.println(scand)


    tmp_pos_str: string = lib.position_to_string(lib.position(&scand))
    fmt.println(tmp_pos_str)


    fmt.println("token end :: ", scand.tok_end)
    fmt.println("token pos :: ", scand.tok_pos)
    fmt.println("char len :: ", scand.prev_char_len)

    run := lib.scan(&scand)
    fmt.println(cast(int)run)

    // fmt.println(token_s)

    token_s = lib.next(&scand)
    if token_s == -1 {
      break READ
    }
  }
}
