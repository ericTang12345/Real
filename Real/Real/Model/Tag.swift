//
//  Tag.swift
//  Real
//
//  Created by 唐紹桓 on 2020/12/24.
//

import Foundation

struct Tag: Codable, Equatable {
    
    var id: String
    
    let title: String
    
    let color: String
    
    let createdTime: FIRTimestamp
}

extension Tag {
    
    static func defaultTag() {
        
        let tags: [Tag] = [
            Tag(id: "", title: "AppWorksSchool", color: "#ED7432", createdTime: FIRTimestamp()),
            Tag(id: "", title: "感情", color: "#FFAAD5", createdTime: FIRTimestamp()),
            Tag(id: "", title: "閒聊", color: "#B15BFF", createdTime: FIRTimestamp()),
            Tag(id: "", title: "笑話", color: "#FF5151", createdTime: FIRTimestamp()),
            Tag(id: "", title: "靈異", color: "#272727", createdTime: FIRTimestamp()),
            Tag(id: "", title: "電影", color: "#9F4D95", createdTime: FIRTimestamp()),
            Tag(id: "", title: "工作", color: "#AD5A5A", createdTime: FIRTimestamp()),
            Tag(id: "", title: "時事", color: "#FF5151", createdTime: FIRTimestamp()),
            Tag(id: "", title: "App", color: "#7373B9", createdTime: FIRTimestamp()),
            Tag(id: "", title: "iOS", color: "#BEBEBE", createdTime: FIRTimestamp()),
            Tag(id: "", title: "Apple", color: "#BEBEBE", createdTime: FIRTimestamp()),
            Tag(id: "", title: "穿搭", color: "#272727", createdTime: FIRTimestamp()),
            Tag(id: "", title: "星座", color: "#02DF82", createdTime: FIRTimestamp()),
            Tag(id: "", title: "音樂", color: "#2894FF", createdTime: FIRTimestamp()),
            Tag(id: "", title: "動漫", color: "#FFDC35", createdTime: FIRTimestamp()),
            Tag(id: "", title: "運動", color: "#F75000", createdTime: FIRTimestamp()),
            Tag(id: "", title: "表特", color: "#921AFF", createdTime: FIRTimestamp()),
            Tag(id: "", title: "其他", color: "#009393", createdTime: FIRTimestamp()),
            Tag(id: "", title: "政治", color: "#005AB5", createdTime: FIRTimestamp()),
            Tag(id: "", title: "心情", color: "#C7C7E2", createdTime: FIRTimestamp()),
            Tag(id: "", title: "議題", color: "#484891", createdTime: FIRTimestamp()),
            Tag(id: "", title: "有趣", color: "#FFF0AC", createdTime: FIRTimestamp()),
            Tag(id: "", title: "認真", color: "#984B4B", createdTime: FIRTimestamp())
        ]
    
        for tag in tags {
            
            let doc = FirebaseManager.shared.getCollection(name: .tag).document()
            
            let newTag = Tag(id: doc.documentID, title: tag.title, color: tag.color, createdTime: tag.createdTime)
            
            FirebaseManager.shared.save(to: doc, data: newTag)
        }
        
        print("儲存完畢")
    }
}
