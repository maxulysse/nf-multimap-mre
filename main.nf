#!/usr/bin/env nextflow

process TEST {
    input:
    val(text)

    output:
    path ("*.txt")

    script:
    """
    echo ${text} > ${text}.txt
    """
}

workflow {
    foo = Channel.of (["A", "B"]).view{"A and B " + it}

    baz = Channel.empty().view{"empty channel: should not print " + it}

    foo_A = foo.map{a, b ->
        [a]
    }.view{"map: Should be a " + it}

    foo_B = foo.map{a, b ->
        null
    }.view{"map: Should be null and not print " + it}


    bar = foo.multiMap{a, b ->
        bar_a: [a]
        bar_b: null
    }

    bar.bar_a.view{"MultiMap: Should be a " + it}
    bar.bar_b.view{"MultiMap: Should be null and not print " + it}

    null_channel = baz.mix(foo_B,bar.bar_b)

    TEST(null_channel)
}