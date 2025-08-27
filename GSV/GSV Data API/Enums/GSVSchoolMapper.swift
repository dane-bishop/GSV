//
//  GSVSchoolMapper.swift
//  GSV
//
//  Created by Melanie Bishop on 8/25/25.
//

import Foundation

enum GSVSchoolMapper {
    /// Fill this gradually. Key however you like; below uses your `schoolFullName`.
    static let byFullName: [String: Int] = [
        "Fort Zumwalt North": 63,
        // "Jackson": 69,
        // ...
        /*
         Bayless High School                |          10
         Bowling Green                      |          17
         Gateway High School                |          25
         Grandview (Hillsboro)              |          29
         DeSoto High School                 |          35
         Central Visual and Performing Arts |          50
         Elsberry High School               |          52
         Centralia High School              |          53
         Clayton High School                |          58
         Farmington High School             |          59
         Festus High School                 |          60
         Ft. Zumwalt North                  |          63
         Ft. Zumwalt South                  |          65
         Crystal City High School           |          68
         Ft. Zumwalt West                   |          69
         Fox High School                    |          70
         Francis Howell                     |          71
         Francis Howell Central             |          72
         Francis Howell North               |          75
         Hazelwood Central                  |          76
         Hazelwood East                     |          78
         Fulton High School                 |          80
         Hazelwood West                     |          81
         Jackson High School                |          82
         Hermann High School                |          83
         Jefferson City                     |          84
         Hickman High School                |          85
         Jennings High School               |          86
         Hillsboro High School              |          93
         Kirkwood High School               |          95
         Ladue Horton Watkins               |         100
         Lafayette (Wildwood)               |         103
         Maplewood-Richmond Hts.            |         106
         Marquette High School              |         109
         McCluer High School                |         113
         McCluer North                      |         116
         McCluer South-Berkeley             |         118
         Mehlville High School              |         122
         Lindbergh High School              |         124
         Metro High School                  |         125
         Mexico High School                 |         128
         Louisiana High School              |         129
         Miller Career Academy              |         131
         Normandy Collaborative             |         138
         North Callaway                     |         139
         North County High School           |         140
         Northwest (Cedar Hill)             |         144
         Hancock High School                |         148
         Oakville High School               |         150
         Parkway Central                    |         160
         Parkway North                      |         161
         Parkway South                      |         162
         Parkway West High School           |         163
         Pattonville High School            |         165
         St. Charles High School            |         168
         St. Charles West                   |         169
         St. Clair High School              |         170
         Potosi High School                 |         171
         Ritenour High School               |         182
         Seckman High School                |         184
         Riverview Gardens                  |         185
         Rockwood Summit                    |         187
         Roosevelt High School              |         189
         Soldan International Studies       |         195
         South Callaway                     |         197
         Union High School                  |         201
         University City                    |         203
         Vashon High School                 |         206
         Sullivan High School               |         207
         Sumner High School                 |         208
         Webster Groves                     |         228
         Wellsville-Middletown              |         229
         Grandview High School              |         237
         Clopton High School                |         271
         Holt High School                   |         320
         Jefferson (Conception)             |         328
         Montgomery County                  |         370
         New Haven High School              |         378
         Orchard Farm High School           |         403
         Pacific High School                |         408
         Perryville High School             |         411
         Silex High School                  |         440
         Ste. Genevieve                     |         459
         Timberland High School             |         472
         Troy Buchanan                      |         476
         Valley Park High School            |         481
         Van-Far High School                |         483
         Warrenton High School              |         489
         Washington High School             |         491
         Windsor (Imperial)                 |         499
         Winfield High School               |         501
         Wright City High School            |         506
         Bishop DuBourg                     |         509
         Cardinal Ritter                    |         511
         Chaminade College Prep             |         512
         The Fulton School                  |         513
         Christian Brothers College         |         514
         Cor Jesu Academy                   |         515
         Crossroads College Preparatory     |         516
         De Smet Jesuit                     |         517
         Duchesne High School               |         518
         Helias Catholic                    |         522
         Incarnate Word Academy             |         523
         John Burroughs                     |         524
         Lutheran St. Charles               |         528
         Lutheran North                     |         529
         Lutheran South                     |         530
         MICDS High School                  |         531
         Nerinx Hall High School            |         532
         Notre Dame (St. Louis)             |         535
         Principia High School              |         538
         Priory High School                 |         539
         Rosati-Kain                        |         541
         St. Dominic High School            |         542
         St. Francis Borgia                 |         544
         St. Joseph's Academy               |         546
         SLUH                               |         547
         St. Mary's South Side              |         549
         St. Pius X (Festus)                |         552
         St. Vincent High School            |         554
         Saxony Lutheran                    |         555
         Trinity Catholic                   |         557
         Ursuline Academy                   |         558
         Vianney High School                |         560
         Villa Duchesne                     |         561
         Visitation Academy                 |         562
         Westminster Christian Academy      |         564
         Whitfield High School              |         565
         Missouri Military Academy          |         569
         Lift for Life Academy Charter      |         810
         McKinley Classical Leadership      |         811
         Veritas Christian Academy HS       |         812
         Jefferson (Festus)                 |         825
         Affton High School                 |           4
         */
    ]

    static func externalId(for school: School) -> Int? {
        byFullName[school.schoolFullName]
    }
}
