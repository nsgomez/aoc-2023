import java.io.BufferedReader
import java.io.File
import java.util.*
import kotlin.collections.ArrayList
import kotlin.math.min

data class MapEntry(val destinationRangeStart: Long, val sourceRangeStart: Long, val rangeLength: Long) : Comparable<MapEntry> {
    override fun compareTo(other: MapEntry) = this.sourceRangeStart.compareTo(other.sourceRangeStart)
}

fun constructMap(reader: BufferedReader): PriorityQueue<MapEntry> {
    val queue = PriorityQueue<MapEntry>()
    do {
        val line = reader.readLine() ?: return queue

        if (line.endsWith(":")) continue
        if (line.isEmpty()) break

        val params = line.split(' ')
        val entry = MapEntry(params[0].toLong(), params[1].toLong(), params[2].toLong())
        queue.offer(entry)
    } while (true)

    return queue
}

fun followMaps(sourceIn: Long, maps: ArrayList<PriorityQueue<MapEntry>>): Long {
    var source = sourceIn
    var lastMapEntry : MapEntry? = null

    maps.forEach {
        for (mapEntry in it) {
            lastMapEntry = mapEntry
            if (source >= mapEntry.sourceRangeStart && source < mapEntry.sourceRangeStart + mapEntry.rangeLength) {
                source = mapEntry.destinationRangeStart + (source - mapEntry.sourceRangeStart)
                break
            }
        }
    }

    return source
}

fun main(args: Array<String>) {
    if (args.isEmpty()) {
        println("Input filename must be passed as argument")
        return
    }

    val reader = File(args[0]).bufferedReader()
    val seeds = ArrayList<Pair<Long, Long>>()

    var seed : Long? = null
    var seedLength : Long? = null
    val seedSpec = reader.readLine().substring(7).split(' ').forEach {
        if (seed == null) seed = it.toLong()
        else {
            seedLength = it.toLong()
            seeds.add(Pair<Long, Long>(seed!!, seedLength!!))

            seed = null
            seedLength = null
        }
    }
    reader.readLine()

    val maps = ArrayList<PriorityQueue<MapEntry>>()
    var map : PriorityQueue<MapEntry>
    do {
        map = constructMap(reader)
        if (!map.isEmpty()) maps.add(map)
        else break
    } while (true)

    var minLocation = Long.MAX_VALUE

    seeds.forEach{
        // lol
        for (i in it.first..<it.first + it.second) {
            minLocation = min(minLocation, followMaps(i, maps))
        }
    }

    println(minLocation)
}
