[% PROCESS svc_util.t -%]
// [% pkg %]_versiontag.h   -*-C++-*-
#ifndef INCLUDED_[% PKG %]_VERSIONTAG
#define INCLUDED_[% PKG %]_VERSIONTAG

#ifndef INCLUDED_BDES_IDENT
#include <bdes_ident.h>
#endif
BDES_IDENT_RCSID([% pkg %]_versiontag_h,"\$Id\$ \$CSID\$ \$CCId\$")
BDES_IDENT_PRAGMA_ONCE

//@PURPOSE: Provide versioning information for the '$pkg' package group.
//
//@SEE_ALSO: [% pkg %]_version
//
//@AUTHOR: [% svc.author %]
//
//@DESCRIPTION: This component provides versioning information for the
[% formatComment("'$pkg' package group.  The '${PKG}_VERSION' macro that is supplied can be used for conditional-compilation based on $pkg version information.  The following usage example illustrates this basic capability.", 0) %]
//
///Usage
///-----
[% formatComment("At compile time, the version of $pkg can be used to select an older or newer way to accomplish a task, to enable new functionality, or to accommodate an interface change.  For example, if the name of a function changes (a rare occurrence, but potentially disruptive when it does happen), the impact on affected code can be minimized by conditionally calling the function by its old or new name using conditional compilation.  In the following, the '#if' preprocessor directive compares '${PKG}_VERSION' (i.e., the latest $pkg version, excluding the patch version) to a specified major and minor version composed using the '${PKG}_MAKE_VERSION' macro:", 0) %]
//..
//  #if [% PKG %]_VERSION > BDE_MAKE_VERSION(1, 3)
//      // Call 'newFunction' for [% pkg %] versions later than 1.3.
//      int result = newFunction();
//  #else
//      // Call 'oldFunction' for [% pkg %] version 1.3 or earlier.
//      int result = oldFunction();
//  #endif
//..

#ifndef INCLUDED_BDESCM_VERSIONTAG
#include <bdescm_versiontag.h>
#endif

#define [% PKG %]_VERSION_MAJOR [% svc.serviceVersionMajor %]

#define [% PKG %]_VERSION_MINOR [% svc.serviceVersionMinor %]

[% SET offsetlen = PKG.length -%]
[% SET offset    = String.new(' ').repeat(offsetlen) -%]
#define [% PKG %]_VERSION BDE_MAKE_VERSION([% PKG %]_VERSION_MAJOR, \
                                  [% offset %][% PKG %]_VERSION_MINOR)
[% formatComment("Construct a composite version number in the range [ 0 .. 999900 ] from the specified '${PKG}_VERSION_MAJOR' and '${PKG}_VERSION_MINOR' numbers corresponding to the major and minor version numbers, respectively, of the current (latest) $pkg release.  Note that the patch version number is intentionally not included.  For example, '${PKG}_VERSION' produces 10300 (decimal) for $pkg version 1.3.1.", 4) %]

#endif

// GENERATED BY [% version %] [% timestamp %]
// ----------------------------------------------------------------------------
// NOTICE:
//      Copyright (C) Bloomberg L.P., [% year.format %]
//      All Rights Reserved.
//      Property of Bloomberg L.P. (BLP)
//      This software is made available solely pursuant to the
//      terms of a BLP license agreement which governs its use.
// ------------------------------- END-OF-FILE --------------------------------