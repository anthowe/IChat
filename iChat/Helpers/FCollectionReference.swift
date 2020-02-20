//
//  FCollectionReference.swift
//  iChat
//
//  Created by Anthony Howe on 12/16/19.
//  Copyright © 2019 Anthony Howe. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}


func reference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}

