//
//  Protocols.swift
//  FinalProject_Insgram
//
//  Created by MINER YANG on 12/11/20.
//  Copyright © 2020 MINER YANG. All rights reserved.
//

import Foundation

protocol UserProfileHeaderDelegate : class{
    func handleEditFollowTapped(for header: UserProfileHeaderCell)
    func setUserStats(for header: UserProfileHeaderCell)
    func handleFollowersTapped(for header: UserProfileHeaderCell)
    func handleFollowingTapped(for header: UserProfileHeaderCell)
}

protocol HomeCellDelegate {
    func handleUsernameTapped(for cell: HomeProfileCell)
    //
    func handleLikeTapped(for cell: HomeProfileCell)
    func handleCommentTapped(for cell: HomeProfileCell)
    func handleViewCommentsTappeed(for cell: HomeProfileCell)
}
